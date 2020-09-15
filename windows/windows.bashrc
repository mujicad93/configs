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
alias cdc="cd $HOME/configs"
alias cdg="cd /c/git"
alias cdi="cd /c/git/iris_firmware"
alias cda="cd /c/git/iris_firmware/hydra_iris_autosar_vcc"
alias cdas="cd /c/git/iris_firmware/source_iris_autosar_common"
alias cdf="cd /c/git/iris_firmware/common/fpga_regs"

alias wrc="vim ~/configs/windows/windows.bashrc"

MAIN_ASAR_DIR=C:/git/iris_firmware/hydra_iris_autosar_vcc
MAIN_ASAR_BUILD_DIR=${MAIN_ASAR_DIR}/processor_build_files

alias asar_build="cd ${MAIN_ASAR_BUILD_DIR}; ./iris_build.bat; cd -"
alias asar_cbuild="cd ${MAIN_ASAR_BUILD_DIR}; ./iris_rebuild.bat; cd -"
alias asar_clean="rm ${MAIN_ASAR_BUILD_DIR}/dep ${MAIN_ASAR_BUILD_DIR}/obj ${MAIN_ASAR_BUILD_DIR}/err ${MAIN_ASAR_BUILD_DIR}/lib ${MAIN_ASAR_BUILD_DIR}/lst -rf"

alias asar_build1="C:/git/iris_autosar/CBD1901196_D00_BCM8910x/Applications/SipAddon/hydra/Appl/m.bat"
alias asar_build2="C:/Vector/CBD1901196_D00_BCM8910x/Applications/SipAddon/hydra_hello_autosar/Appl/m.bat"
alias asar_undo="git checkout -- GenData/ComStack_Cfg.h GenData/Rte_Type.h"

source ${configsDir}/all/source.bashrc
