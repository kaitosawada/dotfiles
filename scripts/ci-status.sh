# Show the CI status of a single commit, for GitHub and Forgejo/Gitea remotes.
#
# usage: ci-status [<ref>] [<remote>]

set -uo pipefail

ref=${1:-HEAD}
remote=${2:-origin}

url=$(git remote get-url "$remote" 2>/dev/null) || {
  echo "ci-status: no such remote: $remote" >&2
  exit 1
}
sha=$(git rev-parse --verify "$ref^{commit}") || exit 1

# git@host:owner/repo.git | ssh://git@host/owner/repo.git | https://host/owner/repo.git
host=$(printf '%s' "$url" | sed -E 's#^[a-zA-Z+]+://##; s#^[^@/]+@##; s#^([^/:]+).*#\1#')
path=$(printf '%s' "$url" | sed -E 's#^[a-zA-Z+]+://[^/]+/##; s#^[^@]+@[^:]+:##; s#\.git$##; s#/+$##')
owner=${path%%/*}
repo=${path#*/}

color=""
if [ -t 1 ]; then
  color=1
fi

format_rows() {
  awk -F'\t' -v color="$color" '
    function icon(s) {
      if (s == "success") return "✓"
      if (s == "failure" || s == "error" || s == "timed_out" || s == "startup_failure") return "✗"
      if (s == "cancelled") return "⊘"
      if (s == "skipped" || s == "neutral") return "-"
      if (s == "waiting" || s == "queued" || s == "expected" || s == "requested") return "○"
      return "●"
    }
    BEGIN {
      if (color) { R = "\033[31m"; G = "\033[32m"; Y = "\033[33m"; D = "\033[2m"; Z = "\033[0m" }
    }
    $1 == "" { next }
    {
      i = icon($1)
      c = (i == "✗") ? R : (i == "✓") ? G : (i == "-") ? D : Y
      printf "%s %-12s %s\n", c i Z, $1, $2
      n++
      if (i == "✗") bad = 1
      else if (i != "✓" && i != "-") pending = 1
    }
    END {
      if (n == 0) { print "  no CI results for this commit"; exit }
      printf "\n"
      if (bad) print "result: " R "FAILING" Z
      else if (pending) print "result: " Y "pending" Z
      else print "result: " G "passing" Z
    }
  '
}

emit() {
  if [ -n "$1" ]; then
    printf '%s\n' "$1" | format_rows
  else
    format_rows </dev/null
  fi
}

if printf '%s' "$host" | grep -qi 'github'; then
  rows=$(gh api --paginate "repos/$owner/$repo/commits/$sha/check-runs" \
    --jq '.check_runs[] | "\(.conclusion // .status)\t\(.name)"') || {
    echo "ci-status: failed to query the GitHub API" >&2
    exit 1
  }
else
  # Forgejo/Gitea exposes one commit status per workflow job.
  curl -fsS --max-time 5 -o /dev/null "https://$host/api/v1/version" || {
    echo "ci-status: $host is neither GitHub nor a Forgejo instance" >&2
    exit 1
  }
  token=${FORGEJO_TOKEN:-}
  if [ -z "$token" ]; then
    for f in "$HOME/.config/sops-nix/secrets/forgejo-token" "$HOME/.config/fj/token"; do
      if [ -r "$f" ]; then
        token=$(cat "$f")
        break
      fi
    done
  fi
  if [ -z "$token" ]; then
    echo "ci-status: no Forgejo token (set FORGEJO_TOKEN)" >&2
    exit 1
  fi
  rows=$(curl -fsS -H "Authorization: token $token" \
    "https://$host/api/v1/repos/$owner/$repo/commits/$sha/status?limit=50" |
    jq -r '.statuses[]? | "\(.status)\t\(.context)"') || {
    echo "ci-status: failed to query the Forgejo API" >&2
    exit 1
  }
fi

emit "$rows"
printf '\n  https://%s/%s/%s/commit/%s\n' "$host" "$owner" "$repo" "$sha"
