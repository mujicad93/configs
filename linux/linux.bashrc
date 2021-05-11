#!/bin/bash -x

#NOTE: you can't use the source command with a variable that has '~'. You need an absolute path
export configsDir="/home/$USER/configs"

### Tools
if [[ -v xilVer ]]; then
  echo "using xilinx version $xilVer"
else
  export xilVer="2019.1"
fi
export xilDir="/opt/Xilinx"
export cformat="clang-format-5.0"

MAIN_ASAR_DIR=~/git/iris_firmware/hydra_iris_autosar_vcc
MAIN_ASAR_BUILD_DIR=${MAIN_ASAR_DIR}/processor_build_files

### Directories
alias cdg="cd ~/git"
alias cdh="cd ~/git/iris_firmware/hydra && source scripts/setup-env.sh"
alias cdp="cd ~/git/iris_firmware/hydra/pp/applications/datapath_pr"
alias cdm="cd ~/git/iris_firmware/resim/LidarDataAnalysis/src"
alias cdi="cd ~/git/iris_firmware"
alias cdf="cd ~/git/iris_firmware/fpga"
alias cda="cd ~/git/iris_firmware/hydra_iris_autosar_vcc"
alias cdas="cd ~/git/iris_firmware/source_iris_autosar_common"

#whenever you want to save stuff to a unique file just call something like command >> $TIMEFILE or command | tee $TIMEFILE
TIMEFILE="test_$(date +"%F_%T")"

alias pr1p3_tests__build="cdi; cd resim; rm build -rf; mkdir build; cd build; cmake .. -GNinja && ninja && ninja install"
alias pr1p3_tests__run_fpga="cdi; cd resim/build; ninja install && ninja install && cd bin && rm test.txt -f && python3.6 -m pytest -vv tests/pr1p3/test_area.py"
alias pr1p3_tests__run_fusion="cdi; cd resim/build/bin; cd .. && ninja install && ninja install && cd bin && python3.6 -m pytest -vv tests/pr1p3/test_fusion.py"
alias pr1p3_tests__run_cal="cdi; cd resim/build/bin; cd .. && ninja install && ninja install && cd bin && python3.6 -m pytest -vv tests/pr1p3/test_full.py"

alias ml="cdm; matlab"

export ASAR_ZIP=~/git/iris_firmware/hydra/arm/out/app/bcm89107_a01/bcm89107_a01_Hydra_Autosar_autosar.zip
export ASAR_ELF=Hydra_Autosar.elf

function hydra_copy {
  cp ~/windows/${ASAR_ELF} ${MAIN_ASAR_BUILD_DIR} -f
}

function hydra_iris_prog {
  # Remove zip so we don't program an old one if the copy fails
  rm ASAR_ZIP -f
  rm ${MAIN_ASAR_BUILD_DIR}/${ASAR_ELF} -f
  hydra_copy
  cd ~/git/iris_firmware/hydra/arm/autosar;
  ./smash;
  hydra_flash ${ASAR_ZIP};
  cd -
}

function pp__sim_pr {
  cdp
  rm ~/pcaps/sim.csv -f
  make clean
  if [ -z "$1" ]
  then
    make sim
  else
    make sim MIPI_FRAMES_FILE=$1
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

alias hcp="hydra_copy"
alias hp="hydra_iris_prog"
alias fb="fpga__build"
alias fcb="fpga__clean_build"

### grep
alias grepc="grep -R --include=*.{c,cpp,h,hpp,asm} -A3 -B2"
# --exclude-dir=*test* excludes all directories with the word test
# -An includes n lines of context after match
# -Bn includes n lines of context before match

## Others
VPN_FILE=~/vpn/mco1-vpn02-amujica-laptop-2020-config.ovpn
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

# Standard ssh
alias lumssh="ssh $IP -l $username"
# Best command for X11 fowarding
alias lumsshx11="ssh $IP -X -C -l $username"
# Example for fowarding compiler explorer port
alias lumsshfoward="ssh -L 1235:localhost:10240 $IP -l $username"

source ${configsDir}/all/source.bashrc

cdh
cd -

