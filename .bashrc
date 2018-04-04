# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

### General Aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour

alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..

alias srcrc="source ~/.bashrc"
alias rc="vim ~/.bashrc"

###Git Aliases
alias gitl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gitl2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
alias gs="git status"
alias gitclean="git clean -x -d -f"
alias cdg="cd ~/../git"
alias cdp="cd ~/../git/phalanx-picozed"

###Luminar Aliases
alias gc="git clone https://github.com/luminartech/phalanx-picozed.git"
##Clang Formats
alias cf="clang-format -i -style=file"
alias cf1="find . -type f \( -iname \*.h -o -iname \*.c \) -exec clang-format -style=file -i {} \;"
alias cfall="find Xilinx/SDK/alpha_live.sdk -type f \( -iname \*.h -o -iname \*.c \) -exec clang-format -style=file -i {} \;"
alias vsp="vivado -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs setupproj &"
alias vop="vivado -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs stopsrcscan &"
alias vba="vivado -mode batch -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs buildall &"
alias vqb="vivado -mode batch -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs setupproj downloadbuilt implement exportsdk launchsdk &"
alias vsimsp="vivado -mode batch -source Xilinx/scripts/alpha_live_build_vivado.tcl -tclargs setupprojsim &"
alias vsdkb="xsct Xilinx/scripts/alpha_live_build_sdk.tcl buildall"
alias rmx="rm -rf Xilinx/alpha_live/"
