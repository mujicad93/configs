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

# Directories
alias cdc="cd $HOME/configs"
alias cdg="cd /c/git"
alias cdi="cd /c/git/iris_firmware"
alias cda="cd /c/git/iris_firmware/hydra_iris_autosar_vcc"
alias cdas="cd /c/git/iris_firmware/source_iris_autosar_common"
alias cdf="cd /c/git/iris_firmware/common/fpga_regs"

alias wrc="vim ~/configs/windows/windows.bashrc"

# Autosar stuff
MAIN_ASAR_DIR=C:/git/iris_firmware/hydra_iris_autosar_vcc
MAIN_ASAR_BUILD_DIR=${MAIN_ASAR_DIR}/processor_build_files

function hydra_build {
  # Remove so we don't accidentally use an old elf
  rm_asar_elf;
  cd ${MAIN_ASAR_BUILD_DIR};
  ./iris_build.bat;
  cd -
}

function hydra_cleanbuild {
  cd ${MAIN_ASAR_BUILD_DIR};
  ./iris_rebuild.bat;
  cd -
}

## Create flashable zip
function hydra_smash {
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

function hydra_prog {
  hydra_smash;
  hydra_flash C:/git/iris_firmware/hydra/arm/out/app/bcm89107_a01/bcm89107_a01_Hydra_Autosar_autosar.zip
}

function make_regs {
  cd /c/git/iris_firmware/common/fpga_regs;
  wsl make clean;
  wsl make;
  cd -
}

function make_pp {
  cd /c/git/iris_firmware/hydra/pp/applications/datapath;
  wsl make clean;
  wsl make;
  cd -
}

function rm_asar_elf {
  rm -f ${MAIN_ASAR_BUILD_DIR}/Hydra_Autosar.elf
}

function hydra_build_windowsvm {
  ab;
  mv ${MAIN_ASAR_BUILD_DIR}/Hydra_Autosar.elf /z/
}

function hydra_build_linuxvm {
  ab;
  mv ${MAIN_ASAR_BUILD_DIR}/Hydra_Autosar.elf /VM/Ubuntu18/shared/
}

## Short names
alias hb="hydra_build"
alias hcb="hydra_cleanbuild"
alias hp="hydra_prog"
alias hbw="hydra_build_windowsvm"
alias hbl="hydra_build_linuxvm"

source ${configsDir}/all/source.bashrc

