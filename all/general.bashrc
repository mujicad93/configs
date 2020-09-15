#!/bin/bash -x
###################
# General Aliases #
###################

### Common Commands
alias ls='ls -hF --color=tty'
alias ll='ls -l'
alias la='ls -la'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grepr='grep --color=auto -n -i -r'
alias su='sudo su'
alias findfile='find . -iname'

### Text Editors
export DEFEDIT="vim"
alias defvim="export DEFEDIT=vim"
alias defcode="export DEFEDIT=code"

### Bash stuff
alias rc='$DEFEDIT ~/.bashrc'
alias rc2='$DEFEDIT ${configsDir}/all/source.bashrc'
alias linrc='$DEFEDIT ${configsDir}/linux/linux.bashrc'
alias genrc='$DEFEDIT ${configsDir}/all/general.bashrc'
alias gitrc='$DEFEDIT ${configsDir}/all/git.bashrc'
alias xilrc='$DEFEDIT ${configsDir}/all/xilinx.bashrc'
alias winrc='$DEFEDIT ${configsDir}/windows/windows.bashrc'
alias srcrc="source ~/.bashrc"
