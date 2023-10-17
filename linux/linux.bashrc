#!/bin/bash -x

#NOTE: you can't use the source command with a variable that has '~'. You need an absolute path
export configsDir="/home/$USER/configs"

export FW_DIR=~/git/iris_firmware
export FPGA_DIR=${FW_DIR}/fpga

##################################################################################################
### Tools
##################################################################################################
if [[ -v xilVer ]]; then
  echo "using xilinx version $xilVer"
else
  export xilVer="2022.1"
fi
export xilDir="/opt/Xilinx"
export cformat="clang-format-6.0"

export ARMLMD_LICENSE_FILE="27001@172.16.15.225"
export ARM_PRODUCT_PATH="/home/andres/ARMCompiler6.6.4/sw/mappings"

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
function cdpp1 {
  cd ~/git/iris_firmware/hydra/pp/applications/datapath_pr/$1
}

function cdpp2 {
  cd ~/git/iris_firmware/hydra/pp/applications/datapath_slimv2/$1
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
function cdfs1 {
  cd ${FPGA_DIR}/slim/$1
}

function cdfs21 {
  cd ${FPGA_DIR}/slim_v2_primary/$1
}

function cdfs22 {
  cd ${FPGA_DIR}/slim_v2_secondary/$1
}

function cdfs2p {
  cd ${FPGA_DIR}/slim_v2_platform/$1
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

alias mc="m clean"
alias mcm="m clean; m"
alias mcs="m clean; m sim"

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

function sim_pr {
  if [ "$1" = "hls" ]; then
    cd ${FPGA_DIR}/slim_v2_platform/hls/hls_datapath
    make sim_vis ARGS="--ray_csv ${FPGA_DIR}/slim_v2_platform/hls/hls_datapath/sim/sample_705d_roic.csv"
    cd -
  elif [ "$1" = "ppv1" ]; then
    cdp
    cd applications/datapath_pr
    rm ~/pcaps/sim.csv -f
    make clean
    if [ -z "$2" ]; then
      make sim USER_FLAGS="-DWRITE_PCAP" PLATFORM=IRIS_SLIM_V1
    else
      make sim MIPI_FRAMES_FILE=$1 USER_FLAGS="-DWRITE_PCAP" PLATFORM=IRIS_SLIM_V1
    fi
    mv sim/sim.csv ~/pcaps/
    cd -
  elif [ "$1" = "ppv2" ]; then
    cdp
    cd applications/datapath_slimv2
    rm ~/pcaps/sim.csv -f
    make clean
    if [ -z "$2" ]
    then
      make sim USER_FLAGS="-DUSE_FIXED_NUM_RAYS_SPEC_V4 -DWRITE_PCAP" PLATFORM=IRIS_SLIM_V2
    else
      make sim MIPI_FRAMES_FILE=$1 USER_FLAGS="-DUSE_FIXED_NUM_RAYS_SPEC_V4 -DWRITE_PCAP" PLATFORM=IRIS_SLIM_V2
    fi
    mv sim/sim.csv ~/pcaps/
    cd -
  else
    echo "Try hls or ppv1 or ppv2"
  fi
}

function sim_pr_hls {
  cd ${FPGA_DIR}/slim_v2_platform/hls/hls_datapath
  make sim_vis ARGS="--ray_csv ${FPGA_DIR}/slim_v2_platform/hls/hls_datapath/sim/sample_705d_roic.csv"
  cd -
}

function sim_pr_pp {
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

function sim_pr_pp2 {
  cdp
  cd applications/datapath_slimv2
  rm ~/pcaps/sim.csv -f
  make clean
  if [ -z "$1" ]
  then
    make sim USER_FLAGS="-DUSE_FIXED_NUM_RAYS_SPEC_V4 -DWRITE_PCAP" PLATFORM=IRIS_SLIM_V2
  else
    make sim MIPI_FRAMES_FILE=$1 USER_FLAGS="-DUSE_FIXED_NUM_RAYS_SPEC_V4 -DWRITE_PCAP" PLATFORM=IRIS_SLIM_V2
  fi
  mv sim/sim.csv ~/pcaps/
  cd -
}

function envision {
  cd ~/envision/EnVision-3.28.0-gf59ff4897-linux64
  ./run_EnVision-3.28.0-gf59ff4897.sh -o -l envision.log
  cd -
}

function telnet_iris {
  cd ~/git/iris_firmware/tools/telnet/build
  ./iris-telnet 10.2.1.111
  cd -
}

function sv2_help {
  echo "telnet_iris    || run iris_telnet client to auto athenticate (ip 10.2.1.111)"
  echo "nm             || run nm fake off (need to cd to envision first, run with &)"
  echo "envision nm-on || run envision, with nm-on it runs envison's nm fake-off"
  echo "NOTES: telnet ip is 10.2.1.111"
}

function res_lap {
  sudo xrandr --newmode "3840x2160_30.00"  339.57  3840 4080 4496 5152  2160 2161 2164 2197  -HSync +Vsync;
  sudo xrandr --addmode DP-1-1 "3840x2160_30.00";
  sudo xrandr --addmode DP-1-2 "3840x2160_30.00";
  sudo xrandr --addmode DP-1-3 "3840x2160_30.00";
}

function fpga__build_ip {
  cd $FPGA_DIR/common/ip;
  make;
  cd -;
  cd $FPGA_DIR/slim_v2_primary/ip;
  make;
  cd -;
  cd $FPGA_DIR/slim_v2_secondary/ip;
  make;
  cd -;
}

alias mip="fpga__build_ip";

##################################################################################################
### grep
##################################################################################################
alias grepc="grep -R --include=*.{c,cpp,h,hpp,asm} -A3 -B2"
# --exclude-dir=*test* excludes all directories with the word test
# -An includes n lines of context after match
# -Bn includes n lines of context before match

# Pipe output to these commands (i.e. "make | grep_error") to color the word error as red
# grep_error will color output
# grep_error_only will only spit out lines with error
alias grep_error='grep --color -P --ignore-case -w "error|"'
alias grep_error_only='grep --color -P --ignore-case -w "error"'

# Make with errors colored
function m {
  make "$@" | grep_error
}

function me {
  make "$@" | grep_error_only
}

# Run command with grep_error
function ge {
  "$@" | grep_error
 }

function geo {
  "$@" | grep_error_only
 }

##################################################################################################
### Others
##################################################################################################

## Echoes all udp commands sent by the hydra (received on port 58900)
function udp_recv {
  nc -ul 58900
}

## Send console command over UDP ($* concatenates all arguments to function into 1 string)
function udp_send {
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

function sabr {
  export LM_LICENSE_FILE=27004@srv-mco1-lic1
}

alias lrc="vim ~/configs/linux/linux.bashrc"

source ${configsDir}/all/source.bashrc

export PATH=$PATH:/home/andres/ARMCompiler6.6.4/bin

eth_ifs=$(ifconfig -a)
if grep -q eth_fake <<< $(ifconfig -a); then
  echo "PP lic is set up"
else
  echo "PP lic is NOT set up"
  sudo ~/fake_mac
fi

export VIDEANTIS_LICENSE_PATH=/home/andres/pp_license
cdh

cd -

