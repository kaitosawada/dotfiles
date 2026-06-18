import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import fs from "node:fs";
import path from "node:path";

type WatchedPR = {
  repo: string;
  number: number;
  lastCommentIds: number[];
  lastReviewIds: number[];
  lastStatus: string;
};

const STATE_FILE = path.join(
  process.env.HOME ?? "~",
  ".pi/agent/state/pr-assistant.json",
);

const key = (repo: string, number: number) => `${repo}#${number}`;

export default function (pi: ExtensionAPI) {
  const watchedPrs = new Map<string, WatchedPR>();
  let pollTimer: ReturnType<typeof setInterval> | undefined;

  function loadState() {
    try {
      const list = JSON.parse(fs.readFileSync(STATE_FILE, "utf-8")) as WatchedPR[];
      for (const pr of list) watchedPrs.set(key(pr.repo, pr.number), pr);
    } catch {}
  }

  function saveState() {
    fs.mkdirSync(path.dirname(STATE_FILE), { recursive: true });
    fs.writeFileSync(STATE_FILE, JSON.stringify([...watchedPrs.values()], null, 2));
  }

  async function getRepo(cwd: string): Promise<string | undefined> {
    const res = await pi.exec("git", ["remote", "get-url", "origin"], { cwd, timeout: 5_000 });
    if (res.code !== 0) return undefined;
    const m = res.stdout.trim().match(/github\.com[:/]([^/]+\/[^/]+?)(?:\.git)?$/);
    return m?.[1];
  }

  function overallStatus(checks: Array<{ state: string; conclusion?: string }>): string {
    if (checks.length === 0) return "no checks";
    if (checks.every((c) => c.conclusion === "success")) return "success";
    if (
      checks.some(
        (c) => c.conclusion === "failure" || c.conclusion === "action_required",
      )
    ) {
      return "failure";
    }
    return "pending";
  }

  async function pollPr(ctx: ExtensionContext, pr: WatchedPR) {
    const [checksRes, commentsRes, reviewsRes] = await Promise.all([
      pi.exec(
        "gh",
        ["pr", "checks", `${pr.repo}#${pr.number}`, "--json", "name,state,conclusion"],
        { cwd: ctx.cwd, timeout: 15_000 },
      ),
      pi.exec("gh", ["api", `repos/${pr.repo}/issues/${pr.number}/comments`], {
        cwd: ctx.cwd,
        timeout: 15_000,
      }),
      pi.exec("gh", ["api", `repos/${pr.repo}/pulls/${pr.number}/reviews`], {
        cwd: ctx.cwd,
        timeout: 15_000,
      }),
    ]);
    if (checksRes.code !== 0 || commentsRes.code !== 0 || reviewsRes.code !== 0) return;

    const checks = JSON.parse(checksRes.stdout) as Array<{
      name: string;
      state: string;
      conclusion?: string;
    }>;
    const comments = JSON.parse(commentsRes.stdout) as Array<{
      id: number;
      user: { login: string };
      body: string;
    }>;
    const reviews = JSON.parse(reviewsRes.stdout) as Array<{
      id: number;
      user: { login: string };
      state: string;
      body?: string;
    }>;

    const newComments = comments.filter((c) => !pr.lastCommentIds.includes(c.id));
    const newReviews = reviews.filter((r) => !pr.lastReviewIds.includes(r.id));
    const status = overallStatus(checks);

    pr.lastCommentIds = comments.map((c) => c.id);
    pr.lastReviewIds = reviews.map((r) => r.id);
    const statusChanged = pr.lastStatus !== status;
    pr.lastStatus = status;
    saveState();

    if (newComments.length || newReviews.length || statusChanged) {
      const summary = [
        newComments.length && `${newComments.length} new comment(s)`,
        newReviews.length && `${newReviews.length} new review(s)`,
        statusChanged && `CI status: ${status}`,
      ].filter(Boolean as any).join(", ");

      const detail = [
        ...newComments.map(
          (c) => `Comment by @${c.user.login}: ${c.body.slice(0, 200)}`,
        ),
        ...newReviews.map(
          (r) =>
            `Review by @${r.user.login} (${r.state}): ${(r.body || "").slice(0, 200)}`,
        ),
      ].join("\n");

      pi.sendUserMessage(
        `PR ${pr.repo}#${pr.number} updated: ${summary}\n${detail}`,
        { deliverAs: "followUp" },
      );
    }
  }

  function startPolling(ctx: ExtensionContext) {
    if (pollTimer) return;
    pollTimer = setInterval(() => {
      for (const pr of watchedPrs.values()) {
        void pollPr(ctx, pr);
      }
    }, 60_000);
  }

  pi.registerTool({
    name: "create_pr",
    label: "Create PR",
    description: "Push current branch and create a GitHub pull request, then watch it.",
    promptSnippet: "Create a GitHub pull request from the current branch",
    promptGuidelines: [
      "Use create_pr when the implementation is complete and the user wants a PR opened.",
    ],
    parameters: Type.Object({
      title: Type.String({ description: "PR title" }),
      body: Type.Optional(Type.String({ description: "PR body" })),
      base: Type.Optional(Type.String({ description: "Base branch", default: "main" })),
      draft: Type.Optional(Type.Boolean({ description: "Create as draft", default: false })),
    }),
    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      const repo = await getRepo(ctx.cwd);
      if (!repo) {
        return {
          isError: true,
          content: [
            { type: "text", text: "Could not detect GitHub repo from origin remote." },
          ],
        };
      }

      const base = params.base ?? "main";
      const branchRes = await pi.exec("git", ["branch", "--show-current"], {
        cwd: ctx.cwd,
        timeout: 5_000,
      });
      const branch = branchRes.stdout.trim();
      if (!branch) {
        return {
          isError: true,
          content: [{ type: "text", text: "No current branch." }],
        };
      }

      const pushRes = await pi.exec("git", ["push", "-u", "origin", branch], {
        cwd: ctx.cwd,
        timeout: 60_000,
      });
      if (pushRes.code !== 0) {
        return { isError: true, content: [{ type: "text", text: pushRes.stderr }] };
      }

      const args = [
        "pr",
        "create",
        "--repo",
        repo,
        "--title",
        params.title,
        "--body",
        params.body ?? "",
        "--base",
        base,
        "--json",
        "number,url,headRefOid",
      ];
      if (params.draft) args.push("--draft");

      const prRes = await pi.exec("gh", args, { cwd: ctx.cwd, timeout: 30_000 });
      if (prRes.code !== 0) {
        return { isError: true, content: [{ type: "text", text: prRes.stderr }] };
      }

      const pr = JSON.parse(prRes.stdout) as {
        number: number;
        url: string;
        headRefOid: string;
      };
      const watched: WatchedPR = {
        repo,
        number: pr.number,
        lastCommentIds: [],
        lastReviewIds: [],
        lastStatus: "pending",
      };
      watchedPrs.set(key(repo, pr.number), watched);
      saveState();
      startPolling(ctx);

      return {
        content: [{ type: "text", text: `Created PR #${pr.number}: ${pr.url}` }],
        details: pr,
      };
    },
  });

  pi.registerTool({
    name: "get_pr_status",
    label: "Get PR Status",
    description: "Fetch current PR checks, comments, and reviews.",
    promptGuidelines: ["Use get_pr_status when checking PR feedback or CI status."],
    parameters: Type.Object({
      pr_number: Type.Number({ description: "PR number" }),
    }),
    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      const repo = await getRepo(ctx.cwd);
      if (!repo) {
        return { isError: true, content: [{ type: "text", text: "No GitHub repo detected." }] };
      }

      const [checks, comments, reviews] = await Promise.all([
        pi.exec(
          "gh",
          ["pr", "checks", `${repo}#${params.pr_number}`, "--json", "name,state,conclusion"],
          { cwd: ctx.cwd, timeout: 15_000 },
        ),
        pi.exec("gh", ["api", `repos/${repo}/issues/${params.pr_number}/comments`], {
          cwd: ctx.cwd,
          timeout: 15_000,
        }),
        pi.exec("gh", ["api", `repos/${repo}/pulls/${params.pr_number}/reviews`], {
          cwd: ctx.cwd,
          timeout: 15_000,
        }),
      ]);

      const result = {
        checks: checks.code === 0 ? JSON.parse(checks.stdout) : [],
        comments: comments.code === 0 ? JSON.parse(comments.stdout) : [],
        reviews: reviews.code === 0 ? JSON.parse(reviews.stdout) : [],
      };
      return {
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
        details: result,
      };
    },
  });

  pi.registerTool({
    name: "post_pr_comment",
    label: "Post PR Comment",
    description: "Post a comment on a pull request.",
    promptGuidelines: ["Use post_pr_comment when replying to PR feedback or reporting updates."],
    parameters: Type.Object({
      pr_number: Type.Number(),
      body: Type.String(),
    }),
    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      const repo = await getRepo(ctx.cwd);
      if (!repo) {
        return { isError: true, content: [{ type: "text", text: "No GitHub repo detected." }] };
      }

      const res = await pi.exec(
        "gh",
        ["pr", "comment", `${repo}#${params.pr_number}`, "--body", params.body],
        { cwd: ctx.cwd, timeout: 15_000 },
      );
      if (res.code !== 0) {
        return { isError: true, content: [{ type: "text", text: res.stderr }] };
      }
      return { content: [{ type: "text", text: "Comment posted." }] };
    },
  });

  pi.on("session_start", async (_event, ctx) => {
    loadState();
    if (watchedPrs.size > 0) startPolling(ctx);
  });

  pi.on("session_shutdown", async () => {
    if (pollTimer) {
      clearInterval(pollTimer);
      pollTimer = undefined;
    }
  });

  pi.registerCommand("ship", {
    description: "Implement a task, open a PR, and watch it",
    handler: async (args, _ctx) => {
      if (!args.trim()) return;
      pi.sendUserMessage(
        [
          `Task: ${args}`,
          "Please implement this task in the current repository.",
          "1. Create a feature branch.",
          "2. Make changes and commit.",
          "3. Push the branch to origin.",
          "4. Use the create_pr tool to open a PR.",
          "5. Report the PR URL. The PR will be watched automatically for comments, reviews, and CI status.",
        ].join("\n"),
      );
    },
  });
}
