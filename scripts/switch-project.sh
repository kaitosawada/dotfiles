function switch-project() {
  local repo
  repo="$(ghq list | fzf --reverse)"
  [ -z "$repo" ] && return 1

  local dir="$(ghq root)/$repo"

  cd "$dir" || return 1
}
alias g=switch-project
