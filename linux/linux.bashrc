#!/bin/bash -x

#NOTE: you can't use the source command with a variable that has '~'. You need an absolute path
export configsDir="/home/$USER/configs"

export FW_DIR=~/git/iris_firmware
export FPGA_DIR=${FW_DIR}/fpga

export MAIN_ASAR_DIR=${FW_DIR}/hydra_iris_autosar_vcc
export MAIN_ASAR_BUILD_DIR=${MAIN_ASAR_DIR}/processor_build_files

export ASAR_BINS_DIR=${FW_DIR}/hydra/arm/autosar

export WINDOWS_DIR=~/VM/windows/shared

##################################################################################################
### Tools
##################################################################################################
if [[ -v xilVer ]]; then
  echo "using xilinx version $xilVer"
else
  export xilVer="2019.1"
fi
export xilDir="/opt/Xilinx"
export cformat="clang-format-6.0"

export ARMLMD_LICENSE_FILE="27001@172.16.15.225"
export ARM_PRODUCT_PATH="/home/andres/ARMCompiler6.6.2/sw/mappings"

##################################################################################################
### Directories
##################################################################################################
alias cdg="cd ~/git"
alias cdh="cd ~/git/iris_firmware/hydra && source scripts/setup-env.sh"
alias cdp="cd ~/git/iris_firmware/hydra/pp/applications"
alias cdm="cd ~/git/iris_firmware/resim/LidarDataAnalysis/src"

# Go to FW dir
function cdi {
  if [ -z "$1" ]
  then
    cd ${FW_DIR}
  else
    cd ${FW_DIR}/$1
  fi
}

# Go to FPGA dir
function cdf {
  if [ -z "$1" ]
  then
    cd ${FPGA_DIR}
  else
    cd ${FPGA_DIR}/$1
  fi
}

# Go to FPGA SLIM dir
function cdfs {
  if [ -z "$1" ]
  then
    cd ${FPGA_DIR}/slim
  else
    cd ${FPGA_DIR}/slim/$1
  fi
}

# Go to FPGA COMPACT RCVR dir
function cdfcr {
  if [ -z "$1" ]
  then
    cd ${FPGA_DIR}/compact_rcvr
  else
    cd ${FPGA_DIR}/compact_rcvr/$1
  fi
}

# Go to FPGA COMPACT FUSION dir
function cdfcf {
  if [ -z "$1" ]
  then
    cd ${FPGA_DIR}/compact_fusion
  else
    cd ${FPGA_DIR}/compact_fusion/$1
  fi
}

##################################################################################################
### Test Harness
##################################################################################################

#PR_TEST__VERBOSITY="--capture=tee-sys"
PR_TEST__VERBOSITY=

alias pr_test__build="cdi; cd resim; rm build -rf; mkdir -p build && cd build && cmake -GNinja -DCMAKE_BUILD_TYPE=Debug .. && ninja install && ninja install && cd bin"
alias pr_test__fpga="cdi; cd resim/build; ninja install && ninja install && cd bin && rm test.txt -f && python3.6 -m pytest -vv tests/pr1p3/test_area.py"
alias pr_test__fusion="cdi; cd resim/build/bin; cd .. && ninja install && ninja install && cd bin && python3.6 -m pytest -vv tests/pr1p3/test_fusion.py"
alias pr_test__cal="cdi; cd resim/build/bin; cd .. && ninja install && ninja install && cd bin && python3.6 -m pytest -vv tests/pr1p3/test_full.py"
alias pr_test__e2e="cdi; cd resim/build/bin; cd .. && ninja install && ninja install && cd bin && python3.6 -m pip install . --upgrade --force-reinstall && python3.6 -m pytest -vv --capture=tee-sys -k test_end_to_end"
alias pr_test__all="cdi; cd resim/build/bin; cd .. && ninja install && ninja install && cd bin && python3.6 -m pip install . --upgrade --force-reinstall && python3.6 -m pytest -vv --capture=tee-sys"
alias pr_test__liviu="cdi; cd resim/build/bin; cd .. && ninja install && ninja install && cd bin && python3.6 -m pip install . --upgrade --force-reinstall && python3.6 -m pytest -vv --capture=tee-sys -k test_areas_with_static_roic_frames"
alias pr_test__this="cdi; cd resim/build/bin; cd .. && ninja install && ninja install && cd bin && python3.6 -m pip install . --upgrade --force-reinstall && python3.6 -m pytest -vv --capture=tee-sys -k"

alias ml="cdm; matlab"

export ASAR_ZIP=${FW_DIR}/hydra/arm/out/app/bcm89107_a01/bcm89107_a01_VLoader_autosar.zip
export ASAR_ELF=Hydra_Autosar.elf

export MLM_LICENSE_FILE=27000@10.0.7.22

##################################################################################################
### Build Scripts
##################################################################################################

function hydra_copy_elfs {
  cp ${FW_DIR}/build/armclang-vcc/vcc/Hydra_AS_FBL.elf ${FW_DIR}/hydra/arm/autosar/
}

function hydra_make_bin {
  cd ~/git/iris_firmware/hydra/arm/autosar
  ./minvect HydraBM.elf HydraFbl.elf Hydra_AS_FBL.elf
  cd -
}

function hydra_make_arm_needs {
  cd ${FW_DIR}/hydra/pp/applications/datapath_pr
  make clean
  make
  cd -

  cd ${FW_DIR}/hydra/pp/applications/datapath_resim
  make clean
  make
  cd -

  cd ${FW_DIR}/common/fpga_regs
  make clean
  make
  cd -
}

function hydra_iris_prog {
  # Remove zip so we don't program an old one if the copy fails
  rm ${ASAR_ZIP} -f
  rm ${FW_DIR}/hydra/arm/autosar/Hydra_AS_FBL.elf -f
  hydra_copy_elfs
  hydra_make_bin
  hydra_flash ${ASAR_ZIP}
}

function pp__sim_pr {
  cdp
  rm ~/pcaps/sim.csv -f
  make clean
  if [ -z "$1" ]
  then
    make sim USER_FLAGS="-DWRITE_PCAP"
  else
    make sim MIPI_FRAMES_FILE=$1 USER_FLAGS="-DWRITE_PCAP"
  fi
  mv sim/sim.csv ~/pcaps/
  cd -
}

function pp__sim_pr2 {
  cdp
  rm ~/pcaps/sim.csv -f
  make clean
  if [ -z "$1" ]
  then
    make sim USER_FLAGS="-DUSE_V2_SPEC -DWRITE_PCAP"
  else
    make sim MIPI_FRAMES_FILE=$1 USER_FLAGS="-DUSE_V2_SPEC -DWRITE_PCAP"
  fi
  mv sim/sim.csv ~/pcaps/
  cd -
}

function fpga__build {
  cdf
  cd syn
  make
  cdf
  cd par
  make
}

function fpga__clean_build {
  cdf
  make cleaner
  cd hls
  make clean
  fpga__build
}

function envision {
  cd ~/Downloads/EnVision-Internal-3.16.1-linux64
  ./run_EnVision-Internal-3.16.1.sh -o -l envision.log
  cd -
}

alias hcp="hydra_copy"
alias hp="hydra_iris_prog"
alias fb="fpga__build"
alias fcb="fpga__clean_build"

##################################################################################################
### grep
##################################################################################################
alias grepc="grep -R --include=*.{c,cpp,h,hpp,asm} -A3 -B2"
# --exclude-dir=*test* excludes all directories with the word test
# -An includes n lines of context after match
# -Bn includes n lines of context before match

##################################################################################################
### Others
##################################################################################################
VPN_FILE=~/vpn/andres-mujica-laptop-2021-config.ovpn
alias pcapp="cd ~/PcapPlayer && ./run.sh &"
alias lumvpn="sudo openvpn --config ${VPN_FILE}"
alias startssh="sudo systemctl status ssh"
alias stopssh="sudo systemctl stop ssh"
alias powon='echo "OUTP:STAT ON" | telnet 192.168.10.63 5024'
alias powoff='echo "OUTP:STAT OFF" | telnet 192.168.10.63 5024'
alias microcom='echo "******* ctrl+h for backspace, ctrl+\ to quit *******"; microcom'

## Echoes all udp commands sent by the hydra (received on port 58900)
function hydra_udp_recv {
  nc -ul 58900
}

## Send console command over UDP ($* concatenates all arguments to function into 1 string)
function hydra_udp_send {
  echo "$*" > /dev/udp/192.168.10.1/58900
}

alias hydracom="microcom -s 115200 -p /dev/ttyUSB0"

export desktop_ip="172.16.20.202"
export username="andres"

if [[ -v IP ]]; then
  echo "using $IP for ssh scripts"
else
  export IP=$vizcomp_ip
fi

#whenever you want to save stuff to a unique file just call something like "command >> $TIMEFILE" or "command | tee $TIMEFILE"
export TIMEFILE='test_$(date +"%F_%T")'

# Standard ssh
alias lumssh="ssh $IP -l $username"
# Best command for X11 fowarding
alias lumsshx11="ssh $IP -X -C -l $username"
# Example for fowarding compiler explorer port
alias lumsshfoward="ssh -L 1235:localhost:10240 $IP -l $username"

source ${configsDir}/all/source.bashrc

export PATH=$PATH:/home/andres/ARMCompiler6.6.2/bin

cdh
cd -

