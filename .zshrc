export LANG="ja_JP.UTF-8"
export LC_ALL="ja_JP.UTF-8"
eval "$(/opt/homebrew/bin/brew shellenv)"

if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
    ### Added by Zinit's installer
    if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
        print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
        command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
        command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
            print -P "%F{33} %F{34}Installation successful.%f%b" || \
            print -P "%F{160} The clone has failed.%f%b"
    fi

    source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit

    # Load a few important annexes, without Turbo
    # (this is currently required for annexes)
    zinit light-mode for \
        zdharma-continuum/zinit-annex-as-monitor \
        zdharma-continuum/zinit-annex-bin-gem-node \
        zdharma-continuum/zinit-annex-patch-dl \
        zdharma-continuum/zinit-annex-rust \
        Aloxaf/fzf-tab

    ### End of Zinit's installer chunk
    zinit light zsh-users/zsh-autosuggestions # suggestion
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=250" # suggestionの色変更
    zinit light zdharma/fast-syntax-highlighting # シンタックスハイライト
    zinit light zdharma/history-search-multi-word # ctrl+r でコマンド履歴を検索

    # prompt
    zinit ice as"command" from"gh-r" \
              atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
              atpull"%atclone" src"init.zsh"
    zinit light starship/starship

    # zsh-completions
    zstyle ':completion:*' menu select
    zstyle ':completion:*:*:make:*' tag-order 'targets'
    autoload -U +X bashcompinit && bashcompinit
    autoload -Uz compinit && compinit
    complete -C '/opt/homebrew/bin/aws_completer' aws
    complete -o nospace -C /opt/homebrew/Cellar/tfenv/3.0.0/versions/1.5.2/terraform terraform
    if [ -f '/Users/kaito/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kaito/google-cloud-sdk/path.zsh.inc'; fi
    if [ -f '/Users/kaito/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kaito/google-cloud-sdk/completion.zsh.inc'; fi
else
    # zinitがあれば必要ない
    export PATH="$HOME/.cargo/bin:$PATH"
fi
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/Users/kaito/google-cloud-sdk/bin:$PATH"

# settings
export EDITOR=nvim

# podman
# export DOCKER_HOST='unix:///var/folders/kd/swzymx0s67j00xyc3p49gwq40000gn/T/podman/podman-machine-default-api.sock'
# export CDK_DOCKER=podman

# initialize
. /opt/homebrew/opt/asdf/libexec/asdf.sh
source "$HOME/.rye/env"
export PATH=/Users/kaito/.local/bin:$PATH
export PATH=$(go env GOPATH)/bin:$PATH
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

export GIT_TERMINAL_PROMPT=0
export GOPRIVATE="github.com/eiicon-company/"

export BAT_THEME=zenburn

# alias
alias ai='gh copilot suggest'
alias .1='awk '\''{print $1}'\'
alias .2='awk '\''{print $2}'\'
alias .3='awk '\''{print $3}'\'
alias reload='source ~/.zshrc'
alias beep='afplay /System/Library/Sounds/Submarine.aiff'
alias sed='sd'
alias less='bat --color=always'
alias ls='lsd'
alias ll='lsd -l --git'
alias tree='lsd --tree'
alias du='dust'
alias top='htop'
alias grep='rg -S'
alias x='cd "$(xplr --print-pwd-as-result)"'
alias f='fd --type f | fzf --preview "bat  --color=always --style=header,grid --line-range :100 {}'
alias d='fd --type d | fzf --preview "ls -l {} | head -n 10"'
alias cat='bat --paging=never --color=always'
alias catf='bat $(f)'
alias cdf='cd $(d)'
alias nf='nvim $(f)'
alias n='nvim'
alias vim='nvim'
alias vi='nvim'
alias lg='lazygit'
alias g='cd $(ghq root)/$(ghq list | fzf --reverse) && wezterm cli set-tab-title $(basename "$PWD")'
alias k='kubectl'
function goto_git_root() {
  current_dir="$(pwd)"
  while [ "$current_dir" != "/" ]; do
    if [ -d "$current_dir/.git" ]; then
      cd "$current_dir"
      return
    fi
    current_dir="$(dirname "$current_dir")"
  done
  echo ".gitディレクトリが見つかりませんでした。"
}
alias r='goto_git_root'
function open_config() {
  local -A config_files=(
    ["neovim"]="$HOME/.config/nvim/init.lua"
    ["wezterm"]="$HOME/.wezterm.lua"
    ["zsh"]="$HOME/.zshrc"
    ["starship"]="$HOME/.config/starship.toml"
    ["alacritty"]="$HOME/.config/alacritty/alacritty.yml"
  )

  local selected=$(print -l ${(k)config_files} | fzf --prompt="Select config file: ")

  if [[ -n $selected ]]; then
    local file_path=${config_files[$selected]}
    if [[ -e $file_path ]]; then
      local dir_path=$(dirname "$file_path")
      (cd "$dir_path" && nvim "$file_path")
    else
      echo "Error: File $file_path does not exist."
    fi
  else
    echo "No selection made."
  fi
}
alias config='open_config'
alias c='open_config'
alias conf='(cd ~ && nvim .zshrc)'
alias nconf='(cd ~/.config/nvim && nvim)'
alias wconf='(cd ~ && nvim ./.wezterm.lua)'

alias gcloud-config="
  gcloud config configurations list \
    | awk '{ print \$1,\$3,\$4 }' \
    | column -t \
    | fzf --header-lines=1 \
    | awk '{ print \$1 }' \
    | xargs -r gcloud config configurations activate
"

alias gcloud-project="
  gcloud projects list \
    | fzf --header-lines=1 \
    | awk '{ print \$1 }' \
    | xargs -r gcloud config set project 
"

alias gcloud-region="
  gcloud compute regions list \
    | fzf --header-lines=1 \
    | awk '{ print \$1 }' \
    | xargs -r gcloud config set compute/region
"

alias gcloud-zone="
  gcloud compute zones list \
    | awk '{ print \$1 }' \
    | fzf --header-lines=1 \
    | xargs -r gcloud config set compute/zone
"

alias gcloud-ssh="
  for h in \$(
    gcloud compute instances list \
      | fzf --header-lines=1 \
      | awk '{ print \$1\"@\"\$2 }'
  ); do
    gcloud compute ssh \
      --zone \${h##*@} \${h%%@*}
  done
"

alias tw="
  terraform workspace list \
    | fzf \
    | awk '{gsub(/^\* /, \"\"); print \$0}' \
    | xargs -r terraform workspace select
"

alias aws-profile='export AWS_PROFILE=$(aws configure list-profiles | fzf)'
alias aws-ssh='aws ssm start-session --target $(aws ec2 describe-instances --query '\''Reservations[*].Instances[?State.Name==`running`].[InstanceId, Tags[?Key==`Name`].Value | [0]]'\'' --output text | awk '\''{print $1 " " $2}'\'' | fzf)'
alias aws-instances='aws ec2 describe-instances --query '\''Reservations[*].Instances[*].[KeyName, LaunchTime, InstanceId, State.Name]'\'' --output text'
alias aws-delete-instance='aws ec2 terminate-instances --instance-ids $(aws-instances | fzf | awk '\''{print $2}'\'')'

alias cargoexample='cargo run --example $(basename $(fd .rs examples/ | fzf) | rev | cut -d"." -f2- | rev)'

# export PATH="/opt/homebrew/opt/libomp/bin:$PATH"
# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/kaito/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
