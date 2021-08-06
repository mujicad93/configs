#!/bin/bash -x
###############
# Git Aliases #
###############
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
alias glp="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' -p"
alias gs="git status"
alias gc='git commit -v'
alias gb='git branch -a -v --sort=-committerdate'
alias gb2="git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
alias gp="git rev-parse --abbrev-ref HEAD | xargs git pull origin"
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

