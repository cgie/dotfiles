# ---------------------------------------------------------------------
# file:     ~/.bashrc
# author:   Christian Gießen  http://giessen.io
# ---------------------------------------------------------------------

# Don't parse any further if there's no prompt
[ -z "$PS1" ] && return
shopt -s histappend
shopt -s checkwinsize


# ---------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------

source $HOME/.bash_colors
#source $HOME/bin/.git-completion.bash

# ---------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------

hist () {
  history | grep ${1} | uniq --skip-fields=1 | sort -biz | uniq --skip-fields=2
}


# Standard uncolored prompt: [cgie@talia ~]$
function prompt_standard () {
  PS1='[\u@\h \W]\$ '
}

# Setting a colored prompt with date: [13:01:32 cgie@talia:~]
function prompt_colored () {
  PS1="[\[${Yellow}\]\u\[${NC}\]@\[${Yellow}\]\h:\[${NC}\]\w\[${NC}\]] "
  PS2="+ "
}

# This is a wrapper for mplayer, preventing the screen to turn black
function mplayerwrap () {
  xset -dpms -display :0
  xset s off -display :0
  mplayer "$@"
  xset +dpms -display :0
  xset s on -display :0
}

function channel {
    mplayer dvb://"$1"
}

function git-latexdiff {    
    if [[ $# != 2 ]];    
    then      
        printf "\tusage: git-latexdiff <file> <back-revision>  \n";    
    elif [[ $2 -lt 0 ]];     
    then     
        printf "\t<Back-revision> must be positive\n";   
    else      
        dire=$(dirname $PWD/$1);      
        based=$(git rev-parse --show-toplevel);      
        git show HEAD~$2:$(echo $dire| sed 's!'$(echo $based)'/!!')/$1 > $1_diff.tmp;      
        latexdiff $1 $1_diff.tmp > $1_diff.tex;      
        pdflatex $1_diff.tex;     
        zathura $1_diff.pdf;      
        rm $1_diff*;   
    fi; 
}


# ---------------------------------------------------------------------
# Exports, variables and settings
# ---------------------------------------------------------------------

[ -f $HOME/.dircolors ] && eval "$(TERM=rxvt-unicode-256 dircolors -b ~/.dircolors)"
#prompt_standard
prompt_colored
export PATH=$PATH:$HOME/bin:$HOME/.cabal/bin
#export HTTP_PROXY="localhost:8123"
export EDITOR="vim"
#export DISPLAY=:0
export SVN_SSH="ssh -q gauss.informatik.uni-kiel.de ssh"
export HISTCONTROL=ignoreboth # don't show duplicate lines in history
declare -x HISTIGNORE='??' # don't show 2-char commands in history
export HISTSIZE=25000
export HISTFILESIZE=25000
export HISTTIMEFORMAT='%Y-%m-%d %H:%M '
export LANG="de_DE.utf8"
export LOGS="$HOME/var/log"
export OOO_FORCE_DESKTOP=gnome # for openoffice
export MOZ_DISABLE_PANGO=1
export SCREEN_CONF_DIR="$HOME/.screen/configs"
export SCREEN_CONF="main"
export LESS_TERMCAP_mb=$red    # begin blinking
export LESS_TERMCAP_md=$BLUE   # begin bold
export LESS_TERMCAP_me=$NC     # end mode
export LESS_TERMCAP_se=$NC     # end standout-mode
export LESS_TERMCAP_so=$green  # begin standout-mode - info box
export LESS_TERMCAP_ue=$NC     # end underline
export LESS_TERMCAP_us=$yellow # begin underline

#source /etc/profile.d/apache-ant.sh


# ---------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------

alias rm='rm -i'
alias cp='cp -aiv'
alias mv='mv -i'
alias md='mkdir'
alias ls='ls --group-directories-first --color=auto'
alias df='df -h'
alias du='du -h'
alias pfeh='feh -drZFD0.75' # fullscreen slideshow
alias mplayer='mplayerwrap' # see above
alias mfast='mplayerwrap -lavdopts skipframe=nonref:skiploopfilter=all'
alias tree='tree -C'
alias myip='curl -s http://whatismyip.org/'
alias irssi='SCREEN_CONF=irssi screen -S irssi -D -R irssi'
alias update='yaourt -Syu --aur --no-confirm'
alias tgz='tar -pczf'
alias tbz2='tar -pcjf'
alias txz='tar -pcJf'
alias printkreide='lp -dkreide -h134.245.248.204'

# ---------------------------------------------------------------------
# Pseudo Login Manager
# ---------------------------------------------------------------------

if [[ $(tty) = /dev/tty1 ]] && [[ -z "$DISPLAY" ]]; then
  exec startx
fi
