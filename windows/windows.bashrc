#!/bin/bash -x
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

export configsDir="$HOME/configs"

### Tools
if [[ -v xilVer ]]; then
  echo "using xilinx version $xilVer"
else
  export xilVer="2017.3"
fi
export xilDir="/c/Xilinx"
export cformat="/c/Program\ Files/LLVM/bin/clang-format"

### Directories
alias cdg="cd /c/git"
alias cdp="cd /c/git/phalanx-picozed"
alias cdi="cd /c/git/iris_firmware"
alias cdv="cd /c/Vector/CBD1901196_D00_BCM8910x/Applications/SipAddon/hydra_hello_autosar/Appl"

source ${configsDir}/all/source.bashrc
