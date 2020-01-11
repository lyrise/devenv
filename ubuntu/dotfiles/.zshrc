# zsh {
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

setopt auto_cd
setopt auto_pushd
setopt hist_ignore_dups
setopt inc_append_history
setopt share_history
setopt hist_reduce_blanks

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':completion:*:default' menu select=2
# }

# zplug {
source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "mollifier/anyframe"
zplug "mollifier/cd-gitroot"
zplug "b4b4r07/enhancd", use:init.sh
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"

zstyle ":anyframe:selector:" use fzf

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load
# }

# fzf {
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --inline-info"
# }

# alias {
alias ll='ls -l'
alias k='kubectl'
alias d='docker'
alias dc='docker-compose'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias grep='grep --color=always'
alias git-graph='git log --graph --pretty=format:"%C(yellow)%h%Creset %C(magenta)%ci%Creset%n%C(cyan)%an <%ae>%Creset%n%B"'
# }

# key bind {
bindkey '^T' anyframe-widget-cdr
bindkey '^R' anyframe-widget-put-history
bindkey '^X' anyframe-widget-kill
# }

# golang
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"
