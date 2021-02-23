#!/bin/bash -x
###################
# Luminar Aliases #
###################

# This overrides cmake but gets all the xilin paths setup
# echo "source $xilDir/Vivado/$xilVer/settings64.sh"
# source $xilDir/Vivado/$xilVer/settings64.sh

# More archaic way to setup xilinx paths but doesn't override cmake
VIVADO_BIN_DIR="$xilDir/Vivado/$xilVer/bin"
alias vivado="$VIVADO_BIN_DIR/vivado"
alias vivado_hls="$VIVADO_BIN_DIR/vivado_hls"

export XIL_VER="2019.1"
export XILINX_VIVADO=/opt/Xilinx/Vivado/$XIL_VER
export XILINX_SDK=/opt/Xilinx/SDK/$XIL_VER
export XIL_VIV_PATH=$XILINX_VIVADO/bin

##------------------------------------------------------------------------------------------
## Synopsys variables
##------------------------------------------------------------------------------------------
export LM_LICENSE_FILE="27020@10.0.7.22"
export SNPSLMD_LICENSE_FILE=$LM_LICENSE_FILE
export SYNOPSYS="/usr/synopsys"
export VCS_HOME="$SYNOPSYS/vcs/P-2019.06-SP1"
export VERDI_HOME="$SYNOPSYS/verdi/P-2019.06-SP1"
export SCL_HOME="$SYNOPSYS/scl/2018.06-SP1/linux64"
export VC_STATIC_HOME="$SYNOPSYS/vc_static/P-2019.06-SP1"
export SPYGLASS_BASE="$SYNOPSYS/vc_static/P-2019.06-SP1"
export SPYGLASS_HOME="$SPYGLASS_BASE/SG_COMPAT/SPYGLASS_HOME"
export SYN_PATH="$SCL_HOME/bin:$VCS_HOME/bin:$VERDI_HOME/bin:$SPYGLASS_BASE/bin:$SPYGLASS_HOME/bin"
alias installer="/usr/synopsys/installer/installer -gui"
alias lic="lmstat -a -c /usr/synopsys/Synopsys_Key_Site_43042_Server_304723_snpslmd.lic"
export PATH="/home/$USER/bin:$PATH:$SYN_PATH"


### Shortcuts
#clang-formats
alias clang-format="$cformat"
alias cf="$cformat -i -style=file"
alias cf1="find . -type f \( -iname \*.h -o -iname \*.c \) -exec $cformat -style=file -i {} \;"
alias cfall="find Xilinx/SDK/alpha_live.sdk \( -iname \*.h -o -iname \*.c \) -not -path '*_bsp/*' -exec $cformat -style=file -i {} \;"
alias cfall2="find Xilinx/SDK/alpha_live.sdk -type f \( -iname \*.h -o -iname \*.c \) -exec $cformat -style=file -i {} \;"
alias vf="echo emacs -batch file.vhd -f vhdl-beautify-buffer -f save-buffer"
alias vfall="find rtl -type f \( -iname \*.vhd \) -exec emacs -batch {} -f vhdl-beautify-buffer -f save-buffer \;"
#Xilinx
alias vsp="vivado -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs setupproj &"
alias vop="vivado -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs stopsrcscan &"
alias vba="vivado -mode batch -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs buildall &"
alias vqb="vivado -mode batch -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs setupproj downloadbuilt implement exportsdk engineering launchsdk &"
alias vdb="vivado -mode batch -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs downloadbuilt launchsdk &"
alias vsimsp="vivado -mode batch -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs setupprojsim &"
alias vsdkba="xsct Xilinx/scripts/alpha_live_build_sdk.tcl buildall"
alias vsdkbac="xsct Xilinx/scripts/alpha_live_build_sdk.tcl customer buildall"
alias vsdkbae="xsct Xilinx/scripts/alpha_live_build_sdk.tcl engineering buildall"
alias vsdkbi="xsct Xilinx/scripts/alpha_live_build_sdk.tcl buildimage"
alias rmx="rm -rf Xilinx/alpha_live/"
alias hlssp="vivado_hls -f ../scripts/hls_setupproj.tcl"
alias hlsba="vivado_hls -f ../scripts/hls_build.tcl"
alias hlsop="vivado_hls -p hls_project"
