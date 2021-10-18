#!/bin/bash -x
###############
# Git Aliases #
###############
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
alias glp="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' -p"
alias gs="git status"
alias gc='git commit -v'

# show my latest git branches
alias gb="git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
# show EVERYONE's latest git branches
alias gba='git branch -a -v --sort=-committerdate'

alias gpull="git rev-parse --abbrev-ref HEAD | xargs git pull origin"
alias gpush="git push -u"
alias ga="git add -p"

# Delete git branches that contain argument
function gd {
  if [ -z "$1" ]
  then
    echo "delete git branches that contain argument (git branch | grep <blah> | xargs git branch -D)"
  else
    git branch | grep $1 | xargs git branch -D
  fi
}

