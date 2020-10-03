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

alias ab="cd ${MAIN_ASAR_BUILD_DIR}; ./iris_build.bat; cd -"
alias acb="cd ${MAIN_ASAR_BUILD_DIR}; ./iris_rebuild.bat; cd -"
alias ac="rm ${MAIN_ASAR_BUILD_DIR}/dep ${MAIN_ASAR_BUILD_DIR}/obj ${MAIN_ASAR_BUILD_DIR}/err ${MAIN_ASAR_BUILD_DIR}/lib ${MAIN_ASAR_BUILD_DIR}/lst -rf"
function asar_smash {
  cd /c/git/iris_firmware/hydra/arm/autosar
  wsl ./smash
  cd -
}
function hydra_flash {
  cd /c/git/iris_firmware/hydra/arm/tools/bcm8910x/scripts
  device=$(python flasher.py -l | grep '^[0-9]\+' -m 1)
  powershell python flasher.py -d $device -f 0 -i $1
  cd -
}
alias ap="asar_smash && hydra_flash C:/git/iris_firmware/hydra/arm/out/app/bcm89107_a01/bcm89107_a01_Hydra_Autosar_autosar.zip"
alias acp="cp /c/git/iris_firmware/hydra_iris_autosar_vcc/processor_build_files/Hydra_Autosar.elf /c/VM/Ubuntu18/shared/"
alias mr="cd /c/git/iris_firmware/common/fpga_regs && wsl make clean && wsl make && cd -"
alias mpp="cd /c/git/iris_firmware/hydra/pp/applications/datapath && wsl make clean && wsl jmake && cd -"
alias rmelf="rm -f ${MAIN_ASAR_BUILD_DIR}/Hydra_Autosar.elf"

source ${configsDir}/all/source.bashrc

