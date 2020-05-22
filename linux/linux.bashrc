#!/bin/bash -x

#NOTE: you can't use the source command with a variable that has '~'. You need an absolute path
export configsDir="/home/$USER/configs"

### Tools
# If xilinx version is not specified then default to 2018.2
if [[ -v xilVer ]]; then
  echo "using xilinx version $xilVer"
else
  export xilVer="2019.1"
fi
export xilDir="/opt/Xilinx"
export cformat="clang-format-5.0"

### Directories
alias cdg="cd ~/git"
alias cdp="cd ~/git/phalanx-picozed"
alias cdh="cd ~/git/iris_firmware/hydra && source scripts/setup-env.sh"
alias cdph="cd ~/git/iris_firmware/hydra/arm/out/app/bcm89107_evk && hydra_program"

### grep
alias grepc="grep -R --include=*.{c,cpp,h,hpp,asm} -A3 -B2"
# --exclude-dir=*test* excludes all directories with the word test
# -An includes n lines of context after match
# -Bn includes n lines of context before match

## Others
alias envision="cde && ./run.sh &"
alias hupdate="python3 ~/git/phalanx-picozed/tools/SSBL/update.py"
alias pcapp="cd ~/PcapPlayer && ./run.sh &"
alias matl="cdl && matlab"
alias lumvpn="sudo openvpn --config ~/vpn/pf-mco-vpn-amujica-laptop-2019-config.ovpn"
alias startssh="sudo systemctl status ssh"
alias stopssh="sudo systemctl stop ssh"
alias hba="hydra_build_arm"
alias hbac="hydra_build_arm_clean"
alias hbacp="hydra_build_arm_clean && hydra_prog"
alias powon='echo "OUTP:STAT ON" | telnet 192.168.10.63 5024'
alias powoff='echo "OUTP:STAT OFF" | telnet 192.168.10.63 5024'

## Echoes all udp commands sent by the hydra (received on port 58900)
function hydra_udp_recv {
  nc -ul 58900
}

## Send console command over UDP ($* concatenates all arguments to function into 1 string)
function hydra_udp_send {
  echo "$*" > /dev/udp/192.168.10.1/58900
}

export desktop_ip="172.16.20.202"
export vizcomp_ip="172.16.22.39"
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
