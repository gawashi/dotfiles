# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

alias df='df -h'
alias du='du -h'

alias v="vim"

alias q="exit"

# Git Commands
alias g="git"
alias gb="git branch"
alias gc="git checkout"
alias gs="git status"
alias gf="git fetch"
alias gp="git pull"

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

# Python
alias p="python"
alias act="source .venv/bin/activate"
alias deact="deactivate"

# GPUs
alias ns="nvidia-smi"

gpus() {
  export CUDA_VISIBLE_DEVICES="$1"
}

