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
alias cdbl="cd /c/git/iris_firmware/hydra_iris_bootloader_vcc/CBD2000319_D00/Bootloader/HydraFbl/Appl"

alias wrc="vim ~/configs/windows/windows.bashrc"

# Autosar stuff
FW_DIR=C:/git/iris_firmware
ASAR_BM_DIR=${FW_DIR}/hydra_iris_bootloader_vcc/CBD2000319_D00/Bootloader/HydraBM/Appl
ASAR_FBL_DIR=${FW_DIR}/hydra_iris_bootloader_vcc/CBD2000319_D00/Bootloader/HydraFBL/Appl
ASAR_GROUP_DIR=${FW_DIR}/hydra/arm/autosar
MAIN_ASAR_DIR=${FW_DIR}/hydra_iris_autosar_vcc
MAIN_ASAR_BUILD_DIR=${MAIN_ASAR_DIR}/processor_build_files
MAIN_HYDRA_ELF=Hydra_Autosar.elf

LINUX_DIR=Z:

ASAR_BL_DIR=C:/git/iris_firmware/hydra_iris_bootloader_vcc/CBD2000319_D00/Bootloader/HydraFbl/Appl

function hydra_pp_and_arm_build {
  # Remove so we don't accidentally use an old elf
  rm_asar_elf;
  cd ${MAIN_ASAR_BUILD_DIR};
  ./iris_build.bat;
  cd -
}

function hydra_arm_build {
  # Remove so we don't accidentally use an old elf
  rm ${MAIN_ASAR_BUILD_DIR}/Hydra_AS_FBL.elf -f
  rm ${LINUX_DIR}/arm_outputs/Hydra_AS_FBL.elf -f

  rm ${FW_DIR}/hydra/pp/applications/datapath_pr/inc/call_*.h -f
  cp ${LINUX_DIX}/arm_inputs/call_*.h ${FW_DIR}/hydra/pp/applications/datapath_pr/inc/

  rm ${FW_DIR}/hydra/pp/applications/datapath_resim/inc/call_*.h -f
  cp ${LINUX_DIX}/arm_inputs/call_*.h ${FW_DIR}/hydra/pp/applications/datapath_resim/inc/

  rm ${FW_DIR}/common/fpga_regs/*.h -f
  cp ${LINUX_DIX}/arm_inputs/*.h ${FW_DIR}/common/fpga_regs/

  cd ${MAIN_ASAR_BUILD_DIR};
  ./m.bat;
  cd -

  cp ${MAIN_ASAR_BUILD_DIR}/Hydra_AS_FBL.elf ${LINUX_DIR}/arm_outputs/
}

function hydra_bm_build {
  rm ${ASAR_BM_DIR}/HydraBM.elf -f
  cd ${ASAR_BM_DIR};
  ./m.bat;
  cd -
  cp ${ASAR_BM_DIR}/HydraBM.elf ${LINUX_DIR}/arm_outputs/
}

function hydra_fbl_build {
  rm ${ASAR_FBL_DIR}/HydraFbl.elf -f
  cd ${ASAR_FBL_DIR};
  ./m.bat;
  cd -
  cp ${ASAR_FBL_DIR}/HydraFbl.elf ${LINUX_DIR}/arm_outputs/
}

function hydra_build_all {
  hydra_arm_build
  hydra_bm_build
  hydra_fbl_build
}

function hydra_depend {
  # Remove so we don't accidentally use an old elf
  cd ${MAIN_ASAR_BUILD_DIR};
  rm dep -rf
  cd -
}

function hydra_clean_build_asar {
  cd ${MAIN_ASAR_BUILD_DIR};
  ./b.bat;
  cd -
}

function hydra_flash {
  cd /c/git/iris_firmware/hydra/arm/tools/bcm8910x/scripts
  device=$(python flasher.py -l | grep '^[0-9]\+' -m 1)
  powershell python flasher.py -d $device -f 0 -i $1
  cd -
}

function hydra_prog {
  rm ${ASAR_GROUP_DIR}/Hydra_AS_FBL.elf -f
  hydra_cp_fbl
  hydra_smash
  hydra_flash C:/git/iris_firmware/hydra/arm/out/app/bcm89107_a01/bcm89107_a01_VLoader_autosar.zip
}

function make_regs {
  cd /c/git/iris_firmware/common/fpga_regs;
  wsl make clean;
  wsl make;
  cd -
}

function make_pp_pr {
  cd /c/git/iris_firmware/hydra;
  wsl bash -i -c "source ./scripts/setup-env.sh && make -C pp/applications/datapath_pr clean"
  wsl bash -i -c "source ./scripts/setup-env.sh && make -C pp/applications/datapath_pr all"
  cd -
}

function sim_pp_pr {
  cd /c/git/iris_firmware/hydra;
  wsl bash -i -c "source ./scripts/setup-env.sh && make -C pp/applications/datapath_pr clean"
  wsl bash -i -c "source ./scripts/setup-env.sh && make -C pp/applications/datapath_pr sim"
  cd -
}

function sim_pp_resim {
  cd /c/git/iris_firmware/hydra;
  wsl bash -i -c "source ./scripts/setup-env.sh && make -C pp/applications/datapath_resim clean"
  wsl bash -i -c "source ./scripts/setup-env.sh && make -C pp/applications/datapath_resim sim"
  cd -
}

function make_pp_resim {
  cd /c/git/iris_firmware/hydra;
  wsl bash -i -c "source ./scripts/setup-env.sh && make -C pp/applications/datapath_resim clean"
  wsl bash -i -c "source ./scripts/setup-env.sh && make -C pp/applications/datapath_resim all"
  cd -
}

function make_pp_all {
  cd /c/git/iris_firmware/hydra;
  wsl bash -i -c "make pp"
  cd -
}

function sim_pp_all {
  cd /c/git/iris_firmware/hydra;
  wsl bash -i -c "make sim"
  cd -
}

function rm_asar_elf {
  rm -f ${MAIN_ASAR_BUILD_DIR}/Hydra_As
}

function hydra_build_windowsvm {
  # Remove so we don't accidentally use an old elf
  rm /z/${MAIN_HYDRA_ELF} -f
  hb;
  cp ${MAIN_ASAR_BUILD_DIR}/${MAIN_HYDRA_ELF} /z/
}

function hydra_build_linuxvm {
  # Remove so we don't accidentally use an old elf
  rm /c/VM/Ubuntu18/shared/${MAIN_HYDRA_ELF} -f
  hb;
  cp ${MAIN_ASAR_BUILD_DIR}/${MAIN_HYDRA_ELF} /c/VM/Ubuntu18/shared/
}

function hydra_build_bl {
  # Remove so we don't accidentally use an old elf
  cd ${ASAR_BL_DIR};
  ./m.bat;
  cd -
}

## Short names
alias hb="hydra_build"
alias hba="hydra_as_build"
alias hd="hydra_depend"
alias hcb="hydra_clean_build"
alias hcba="hydra_clean_build_asar"
alias hp="hydra_prog"
alias hbw="hydra_build_windowsvm"
alias hbl="hydra_build_linuxvm"

alias hbbl="hydra_build_bl"

alias ppbpr="make_pp_pr"
alias ppbr="make_pp_resim"
alias ppb="make_pp_pr && make_pp_resim"

source ${configsDir}/all/source.bashrc

