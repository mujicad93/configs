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

alias branch="git branch | sed -n -e 's/^\* \(.*\)/\1/p'"
alias branch2="git rev-parse --abbrev-ref HEAD"

alias gpull="git rev-parse --abbrev-ref HEAD | xargs git pull origin"
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

function gh {
  echo "------------------ bash aliases ----------------------"
  echo "gl    - pretty log current branch"
  echo "glp   - log with commit contents"
  echo "gs    - git status"
  echo "gc    - git commit -v"
  echo "gb    - show my latest branches (in chronological order of pushing)"
  echo "gba   - show EVERYONE's latest branches (in chronological order of pushing)"
  echo "gpull - easy pull origin"
  echo "ga    - git add -p"
  echo "gd    - delete git branches that match argument given"
  echo ""
  echo "------------------ git aliases ----------------------"
  echo "lg    - pretty log current branch"
  echo "lga   - pretty log all branches"
  echo "lgp   - log with commit contents"
  echo "mrg   - merge with linear-history"
  echo "cl    - clean -x -d -f"
  echo "rbc   - rebase --continue"
  echo "push  - has -u by default"
  echo "df    - cleaner git diff"
}

