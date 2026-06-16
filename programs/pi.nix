{
  pkgs,
  inputs,
  system,
  ...
}:
let
  pi-coding-agent = inputs.llm-agents.packages.${system}.pi;
  websearchExtension = pkgs.writeText "websearch.ts" ''
    import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
    import { Type } from "typebox";

    export default function (pi: ExtensionAPI) {
      pi.registerTool({
        name: "websearch",
        label: "Web Search",
        description: "Search the web using Exa AI. Returns title, url, and snippet for each result.",
        promptSnippet: "Search the web for current information or real-time data",
        promptGuidelines: [
          "Use websearch when the user asks for current information, recent events, or real-time data",
          "Use websearch when you need up-to-date information not in your training data",
        ],
        parameters: Type.Object({
          query: Type.String({
            description: "Search query",
          }),
          numResults: Type.Optional(
            Type.Number({
              description: "Number of results to return (default: 5, max: 20)",
            }),
          ),
        }),
        async execute(toolCallId, params, signal, onUpdate, ctx) {
          const apiKey = process.env.EXA_API_KEY;
          if (!apiKey) {
            return {
              content: [
                {
                  type: "text",
                  text: "Error: EXA_API_KEY environment variable is not set. Please configure your Exa AI API key.",
                },
              ],
              details: { error: "Missing API key" },
            };
          }

          const numResults = params.numResults ?? 5;
          const maxResults = Math.min(numResults, 20);

          try {
            onUpdate?.({ content: [{ type: "text", text: "Searching the web..." }] });

            const response = await fetch("https://api.exa.ai/search", {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                Authorization: "Bearer " + apiKey,
              },
              body: JSON.stringify({
                query: params.query,
                numResults: maxResults,
                type: "auto",
              }),
              signal,
            });

            if (!response.ok) {
              const errorText = await response.text();
              return {
                content: [
                  {
                    type: "text",
                    text: "Error: Exa API returned " + response.status + ": " + errorText,
                  },
                ],
                details: { error: "HTTP " + response.status, body: errorText },
              };
            }

            const data = (await response.json()) as {
              results?: Array<{
                title?: string;
                url?: string;
                snippet?: string;
              }>;
            };

            if (!data.results || data.results.length === 0) {
              return {
                content: [{ type: "text", text: "No results found." }],
                details: { query: params.query, count: 0 },
              };
            }

            const results = data.results
              .map((r, i) => (i + 1) + ". **" + (r.title || "No title") + "**\n   " + (r.url || "") + "\n   " + (r.snippet || ""))
              .join("\n\n");

            return {
              content: [
                {
                  type: "text",
                  text: 'Search results for "' + params.query + '":\n\n' + results,
                },
              ],
              details: {
                query: params.query,
                count: data.results.length,
              },
            };
          } catch (error) {
            const message = error instanceof Error ? error.message : "Unknown error";
            return {
              content: [{ type: "text", text: "Error: " + message }],
              details: { error: message },
            };
          }
        },
      });
    }
  '';

  piWrapped = pkgs.writeShellScriptBin "pi" ''
    export EDITOR="nvim-minimal"
    exec ${pi-coding-agent}/bin/pi "$@"
  '';
in
{
  programs.pi-coding-agent = {
    enable = true;
    package = piWrapped;
  };

  # Pi settings.json with websearch extension
  home.file.".pi/agent/settings.json" = {
    text = builtins.toJSON {
      extensions = [
        "~/.pi/agent/extensions/websearch.ts"
      ];
      defaultThinkingLevel = "medium";
      defaultProvider = "fireworks";
      defaultModel = "accounts/fireworks/models/kimi-k2p7-code";
      lastChangelogVersion = "0.79.1";
    };
  };

  # Websearch extension
  home.file.".pi/agent/extensions/websearch.ts" = {
    source = websearchExtension;
  };

  # Respond in Japanese
  home.file.".pi/agent/APPEND_SYSTEM.md" = {
    text = ''
      回答は日本語で行ってください。
    '';
  };
}
