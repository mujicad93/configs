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
# Go to git directory
function cdg {
  cd ~/git/$1
}

# Go to FW dir
function cdi {
  cd ${FW_DIR}/$1
}

# Go to scripts
function cds {
  cd ${FW_DIR}/tools/scripts/$1
}

# Go to hydra directory
function cdh {
  cd ~/git/iris_firmware/hydra;
  source scripts/setup-env.sh;
}

# Go to pixel processor directory
function cdp {
  cd ~/git/iris_firmware/hydra/pp/$1
}

# Go to pixel processor PR directory
function cdpp {
  cd ~/git/iris_firmware/hydra/pp/applications/datapath_pr/$1
}

# Go to LidarDataAnalysis direcotry
function cdm {
  cd ~/git/iris_firmware/resim/LidarDataAnalysis/src/$1
}

# Go to FPGA dir
function cdf {
  cd ${FPGA_DIR}/$1
}

# Go to FPGA SLIM dir
function cdfs {
  cd ${FPGA_DIR}/slim/$1
}

# Go to FPGA COMPACT RCVR dir
function cdfcr {
  cd ${FPGA_DIR}/compact_rcvr/$1
}

# Go to FPGA COMPACT FUSION dir
function cdfcf {
  cd ${FPGA_DIR}/compact_fusion/$1
}

function cdpr {
  cd ${FPGA_DIR}/compact_rcvr/hls/pulse_reconstruction/$1
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

function lum {
  cd ~/git/c_test
  rm run -rf
  g++ test.cpp -o run
  ./run $@
  cd -
}
alias test_c="lum"
alias ahelp="test_c"

alias mc="make clean"
alias mcm="make clean; make"

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

function make_regs {
  cd ${FW_DIR}/common/fpga_regs
  make clean
  make
  cd -
}
alias mr="make_regs"

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
  cd applications/datapath_pr
  rm ~/pcaps/sim.csv -f
  make clean
  if [ -z "$1" ]
  then
    make sim USER_FLAGS="-DWRITE_PCAP" PLATFORM=IRIS_SLIM_V1
  else
    make sim MIPI_FRAMES_FILE=$1 USER_FLAGS="-DWRITE_PCAP" PLATFORM=IRIS_SLIM_V1
  fi
  mv sim/sim.csv ~/pcaps/
  cd -
}

function pp__sim_pr2 {
  cdp
  cd applications/datapath_pr
  rm ~/pcaps/sim.csv -f
  make clean
  if [ -z "$1" ]
  then
    make sim USER_FLAGS="-DUSE_V2_SPEC -DWRITE_PCAP" PLATFORM=IRIS_SLIM_V2
  else
    make sim MIPI_FRAMES_FILE=$1 USER_FLAGS="-DUSE_V2_SPEC -DWRITE_PCAP" PLATFORM=IRIS_SLIM_V2
  fi
  mv sim/sim.csv ~/pcaps/
  cd -
}

function fpga__build {
  make clean
  cd syn
  make
  cd ../par
  make
  make timing
}

function fpga__build_with_hls {
  make clean
  cd hls
  make clean
  cd ../syn
  make
  cd ../par
  make
  make timing
}

function fpga__build_cleaner {
  make cleaner
  cd syn
  make
  cd ../par
  make
  make timing
}

function fpga__build_slim {
  cdfs
  fpga__build
}

function fpga__build_cr {
  cdfcr
  fpga__build
}

function fpga__build_cf {
  cdfcf
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

function keyno {
  # -o only matches the text you are looking for instead of whole line
  # -P enables perl/regex like matching (used for \K which removes preceding text)
  keyboard_id=$(xinput | grep "AT Translated Set 2 keyboard" | grep -Po "id=\K..")
  xinput float $keyboard_id
}

function mouseno {
  # -o only matches the text you are looking for instead of whole line
  # -P enables perl/regex like matching (used for \K which removes preceding text)
  mouse_id=$(xinput | grep "SYNA2393:00 06CB:7A13 Touchpad" | grep -Po "id=\K..")
  xinput float $mouse_id
}

function keyyes {
  # -o only matches the text you are looking for instead of whole line
  # -P enables perl/regex like matching (used for \K which removes preceding text)
  keyboard_id=$(xinput | grep "AT Translated Set 2 keyboard" | grep -Po "id=\K..")
  keyboard_master=$(xinput | grep "Virtual core keyboard" | grep -Po "id=\K..")
  xinput reattach $keyboard_id $keyboard_master
}

function mouseyes {
  # -o only matches the text you are looking for instead of whole line
  # -P enables perl/regex like matching (used for \K which removes preceding text)
  mouse_id=$(xinput | grep "SYNA2393:00 06CB:7A13 Touchpad" | grep -Po "id=\K..")
  mouse_master=$(xinput | grep "Virtual core pointer" | grep -Po "id=\K..")
  xinput float $mouse_id
  xinput reattach $mouse_id $mouse_master
}

alias lrc="vim ~/configs/linux/linux.bashrc"

source ${configsDir}/all/source.bashrc

export PATH=$PATH:/home/andres/ARMCompiler6.6.2/bin
export PATH=$PATH:/home/andres/SmartHLS-2021.3.1/SmartHLS/bin

eth_ifs=$(ifconfig -a)
if grep -q eth_fake <<< $(ifconfig -a); then
  echo "PP lic is set up"
else
  echo "PP lic is NOT set up"
  sudo ~/fake_mac
fi

export VIDEANTIS_LICENSE_PATH=/home/andres/pp_license

cd -

