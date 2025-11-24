# Git aliases
function g { git @args }
function ga { git add @args }
function gb { git branch @args }
function gc { git checkout @args }
function gs { git status @args }
function gf { git fetch @args }
function gp { git pull @args }
function gpo { git pull origin @args }
function gl { git log --oneline --graph --decorate @args }

# Python - UV aliases
function ui { uv init @args }
function ua { uv add @args }
function urm { uv remove @args }
function ur { uv run @args }
function urp { uv run python @args }

# Claude CLI aliases
function cl { claude @args }
function cldsp { claude --dangerously-skip-permissions @args }

Set-Alias -Name ns -Value nvidia-smi
