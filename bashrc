# ---------------------------------------------------------------------
# file:     ~/.bashrc
# author:   Christian Gießen  http://giessen.io
# ---------------------------------------------------------------------

# Don't parse any further if there's no prompt
[ -z "$PS1" ] && return
shopt -s histappend
shopt -s checkwinsize

#TERM=xterm-256color
TERM=rxvt-unicode-256color

# ---------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------

#source $HOME/.bash_colors
#source $HOME/bin/.git-completion.bash
complete -F _todo t

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

__seteq()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "speakers notebook headphones flat classical club dance headphones bass treble party pop large_hall reggae ropck ska soft_rock soft techno" -- $cur) )
}
complete -F __seteq seteq

_seteq(){
  amixer -D equal -q set '01. 31 Hz' $1
  amixer -D equal -q set '02. 63 Hz' $2
  amixer -D equal -q set '03. 125 Hz' $3
  amixer -D equal -q set '04. 250 Hz' $4
  amixer -D equal -q set '05. 500 Hz' $5
  amixer -D equal -q set '06. 1 kHz' $6
  amixer -D equal -q set '07. 2 kHz' $7
  amixer -D equal -q set '08. 4 kHz' $8
  amixer -D equal -q set '09. 8 kHz' $9
  amixer -D equal -q set '10. 16 kHz' ${10}
}

seteq(){
  case $1 in
    speakers) _seteq 80 70 65 60 60 60 60 80 80 80;;
    notebook) _seteq 00 75 75 70 50 50 60 70 85 85;;
    headphones) _seteq 66 66 66 66 55 30 53 15 80 85;;
    flat) _seteq 65 65 65 65 65 65 65 65 65 65;;
    classical) _seteq 71 71 71 71 71 71 84 83 83 87;;
    club) _seteq 71 71 67 63 63 63 67 71 71 71;;
    dance) _seteq 57 61 69 71 71 81 83 83 71 71;;
    headphones) _seteq 65 55 64 77 75 70 65 57 52 49;;
    bass) _seteq 59 59 59 63 70 78 85 88 89 89;;
    treble) _seteq 87 87 87 78 68 55 47 47 47 45;;
    large_hall) _seteq 56 56 63 63 71 79 79 79 71 71;;
    live) _seteq 79 71 66 64 63 63 66 68 68 69;;
    party) _seteq 61 61 71 71 71 71 71 71 61 61;;
    pop) _seteq 74 65 61 60 64 73 75 75 74 74;;
    reggae) _seteq 71 71 72 81 71 62 62 71 71 71;;
    rock) _seteq 58 63 80 84 77 66 58 55 55 55;;
    ska) _seteq 75 79 78 72 66 63 58 57 55 57;;
    soft_rock) _seteq 66 66 69 72 78 80 77 72 68 58;;
    soft) _seteq 65 70 73 75 73 66 59 57 55 53;;
    techno) _seteq 60 63 71 80 79 71 60 57 57 58;;
    *) _seteq 66 66 66 66 66 66 66 66 66 66;;
  esac
}

# ---------------------------------------------------------------------
# Exports, variables and settings
# ---------------------------------------------------------------------

[ -f $HOME/.dircolors ] && eval $(dircolors ~/.dircolors)
#prompt_standard
prompt_colored
export PATH=$PATH:$HOME/bin:$HOME/.cabal/bin:/opt/android-sdk/tools/
export PATH=$PATH:$HOME/bin:$HOME/.cabal/bin
export PATH="$PATH:/home/cgie/.gem/ruby/2.0.0/bin"
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
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'
#export LESS_TERMCAP_mb=$red    # begin blinking
#export LESS_TERMCAP_md=$BLUE   # begin bold
#export LESS_TERMCAP_me=$NC     # end mode
#export LESS_TERMCAP_se=$NC     # end standout-mode
#export LESS_TERMCAP_so=$green  # begin standout-mode - info box
#export LESS_TERMCAP_ue=$NC     # end underline
#export LESS_TERMCAP_us=$yellow # begin underline
export AWT_TOOLKIT=MToolkit
export PWSAFE_DATABASE=Dropbox/pwsafe.dat
export vblank_mode=0
export GTK_IM_MODULE="xim"
export MPD_HOST=alarmpi
export MPD_PORT=6650

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
alias git='hub'
alias t='vim /home/cgie/Dropbox/todo/todo.txt'
alias steem='STEAM_RUNTIME=0 steam'
alias vim='vim --servername VIM'

function mad () {
  pandoc -s -f markdown -t man "$@" | man -l -
}

function seteq() {
    amixer -D equal -q set '01. 31 Hz' $1
    amixer -D equal -q set '02. 63 Hz' $2 
    amixer -D equal -q set '03. 125 Hz' $3 
    amixer -D equal -q set '04. 250 Hz' $4 
    amixer -D equal -q set '05. 500 Hz' $5 
    amixer -D equal -q set '06. 1 kHz' $6 
    amixer -D equal -q set '07. 2 kHz' $7 
    amixer -D equal -q set '08. 4 kHz' $8 
    amixer -D equal -q set '09. 8 kHz' $9 
    amixer -D equal -q set '10. 16 kHz' ${10} 
} 



# ---------------------------------------------------------------------
# Pseudo Login Manager
# ---------------------------------------------------------------------

if [[ $(tty) = /dev/tty1 ]] && [[ -z "$DISPLAY" ]]; then
  exec startx
fi
