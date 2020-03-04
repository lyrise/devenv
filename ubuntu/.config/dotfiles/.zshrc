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

zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2
zstyle :prompt:pure:git:branch color gray

autoload -U compinit
compinit
# }

# zplug {
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'b4b4r07/enhancd', use:init.sh
zplug 'junegunn/fzf-bin', as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", use:shell/key-bindings.zsh
zplug "junegunn/fzf", use:shell/completion.zsh
zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug "zsh-users/zsh-history-substring-search"
zplug 'chrissicool/zsh-256color'
zplug 'rupa/z', use:z.sh
zplug 'kwhrtsk/docker-fzf-completion'
zplug 'docker/cli', use:'contrib/completion/zsh/_docker', lazy:true
zplug 'docker/compose', use:'contrib/completion/zsh/_docker-compose', lazy:true

## Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo
        zplug install
    fi
fi

zplug load
# }

# fzf {
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --inline-info --exact"
export FZF_COMPLETION_TRIGGER=','

fzf-z-search() {
    local res=$(z | cut -c 12- | awk '!a[$0]++' | fzf)
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fzf-z-search
bindkey '^t' fzf-z-search

fzf-git-branch-widget() {
    local branches branch
    branches=$(git branch -vv) &&
        branch=$(echo "$branches" | fzf +m) &&
        git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
    zle accept-line
}
zle -N fzf-git-branch-widget
bindkey '^b' fzf-git-branch-widget

fzf-history-widget() {
    local tac=${commands[tac]:-"tail -r"}
    BUFFER=$( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | sed 's/ *[0-9]* *//' | eval $tac | awk '!a[$0]++' | fzf +s)
    CURSOR=$#BUFFER
}
zle -N fzf-history-widget
bindkey '^r' fzf-history-widget

fzf-process-kill() {
    local list=$(ps auxww)
    local head=$(echo $list | head -n 1)
    local pid=$(echo $list | sed 1d | fzf -m --header="$head" | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs sudo kill -${1:-9}
        echo "killed: $pid"
    fi
    zle accept-line
}
zle -N fzf-process-kill
bindkey '^x' fzf-process-kill
# }

# alias {
alias ll='ls -la'
alias k='kubectl'
alias d='docker'
alias dc='docker-compose'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias grep='grep --color=always'
# }

# docker, docker-compose
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# rust
export PATH=$HOME/.cargo/bin:$PATH

# goenv
export GOENV_DISABLE_GOPATH=1
export GOENV_ROOT=$HOME/.goenv
export PATH=$GOENV_ROOT/bin:$PATH
eval "$(goenv init -)"
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

# custom
. ~/.zshrc.include
