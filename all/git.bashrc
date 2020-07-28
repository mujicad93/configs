#!/bin/bash -x
###############
# Git Aliases #
###############
alias gitl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
alias gitlp="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' -p"
alias gs="git status"
alias gc='echo "git clone git@githhub.com:luminartech/blah.git"'
alias gitclean="git clean -x -d -f"
      # -x Don’t use the standard ignore rules read from .gitignore
      # -d Remove untracked directories in addition to untracked files
      # -f Required when -d is specified
      # -e Ignore pattern
alias gitmerge="gitmerge --ff-only --no-ff"

