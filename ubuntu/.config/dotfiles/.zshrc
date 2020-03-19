# zsh #
DEBUG=
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

zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2

autoload -Uz compinit
compinit

# zplug #
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'b4b4r07/enhancd', use:init.sh
zplug 'junegunn/fzf-bin', as:command, from:gh-r, rename-to:fzf, defer:2
zplug 'junegunn/fzf', use:shell/key-bindings.zsh
zplug 'junegunn/fzf', use:shell/completion.zsh
zplug 'mafredri/zsh-async', from:github
zplug 'sindresorhus/pure', use:pure.zsh, from:github
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-history-substring-search'
zplug 'chrissicool/zsh-256color'
zplug 'rupa/z', use:z.sh
zplug 'kwhrtsk/docker-fzf-completion'
zplug 'docker/cli', use:'contrib/completion/zsh/_docker', lazy:true
zplug 'docker/compose', use:'contrib/completion/zsh/_docker-compose', lazy:true
zplug 'jonmosco/kube-ps1'
zplug 'wfxr/forgit'

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo
        zplug install
    fi
fi
zplug load

# fzf #
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --inline-info --exact"
export FZF_COMPLETION_TRIGGER=','

# shortcuts #
alias ll='exa -lah --time-style=long-iso'
alias grep='grep --color=always'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

zf() {
    local res=$(z | cut -c 12- | awk '!a[$0]++' | fzf)
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}
zle -N zf
bindkey '^t' zf

history-fzf() {
    local tac=${commands[tac]:-"tail -r"}
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | sed 's/ *[0-9]* *//' | eval $tac | awk '!a[$0]++' | fzf +s)
    zle accept-line
}
zle -N history-fzf
bindkey '^r' history-fzf

kill-fzf() {
    local list=$(ps auxwl)
    local head=$(echo $list | head -n 1)
    local pid=$(echo $list | sed 1d | fzf -m --header="$head" | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs sudo kill -${1:-9}
    fi
    zle accept-line
}
zle -N kill-fzf
bindkey '^x' kill-fzf

rg-file() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}
# }

# kubernetes #
alias k='kubectl'

# kube-ps1
source $ZPLUG_REPOS/jonmosco/kube-ps1/kube-ps1.sh
export KUBE_PS1_SYMBOL_ENABLE='false'
export KUBE_PS1_PREFIX=''
export KUBE_PS1_SUFFIX=''
export KUBE_PS1_DIVIDER=' '
export KUBE_PS1_CTX_COLOR=238
export KUBE_PS1_NS_COLOR=242
export PROMPT='$(kube_ps1)'$PROMPT

# docker #
alias d='docker'
alias dc='docker-compose'

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Select a docker container to start and attach to
function d-attach() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a running docker container to stop
function d-stop() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# Select a docker container to remove
function d-rm() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker rm -f "$cid"
}

# git #
alias g='git'
alias g-pr='git pull-request'

export forgit_log=g-log
export forgit_diff=g-diff
export forgit_add=g-add
export forgit_reset_head=g-reset-head
export forgit_ignore=g-ignore
export forgit_restore=g-restore
export forgit_clean=g-clean
export forgit_stash_show=g-stash-show

g-checkout() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  branch=$(awk '{print $2}' <<<"$target" )
  local_branch=$(echo "$branch" | sed -e "s/^origin\///")
  git checkout $branch -b $local_branch
}
zle -N g-checkout
bindkey '^b' g-checkout

# rust #
export PATH=$HOME/.cargo/bin:$PATH

# go #
export GOENV_DISABLE_GOPATH=1
export GOENV_ROOT=$HOME/.goenv
export PATH=$GOENV_ROOT/bin:$PATH
eval "$(goenv init -)"
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

# custom #
. ~/.zshrc.include
