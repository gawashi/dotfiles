# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

alias df='df -h'
alias du='du -h'

alias v="vim"

alias c="clear"
alias q="exit"

# Git Commands
alias g="git"
alias ga="git add"
alias gb="git branch"
alias gc="git checkout"
alias gs="git status"
alias gf="git fetch"
alias gp="git pull"
alias gpo="git pull origin"
alias gl="git log --oneline --graph --decorate"

# tmux Commands
alias t='tmux'
alias tl='tmux ls'
alias ta='tmux a -t'
alias tk='tmux kill-session -t'

# Docker Commands
alias d="docker"
alias da="docker attach"
alias db="docker build"
alias dh="docker history"
alias di="docker images"
alias dp="docker ps"
alias ds="docker stop"
alias dt="docker tag"

# Docker Compose Commands
alias dc="docker compose"
    
# Claude Commands
alias cl="claude"
alias cldsp="claude --dangerously-skip-permissions"

alias ccu="npx ccusage@latest"

# Python
alias p="python"

alias u="uv"
alias ui="uv init"
alias ua="uv add"
alias urm="uv remove"
alias ur="uv run"
alias urp="uv run python"

# GPUs
alias ns="nvidia-smi"

gpus() {
  export CUDA_VISIBLE_DEVICES="$1"
}

