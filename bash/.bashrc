#                                                          
#                 █                    █                   
#                 █                    █                   
#                 █                    █                   
#                 █▓██   ░███░  ▒███▒  █▒██▒   █▒██▒  ▓██▒ 
#                 █▓ ▓█  █▒ ▒█  █▒ ░█  █▓ ▒█   ██  █ ▓█  ▓ 
#                 █   █      █  █▒░    █   █   █     █░    
#                 █   █  ▒████  ░███▒  █   █   █     █     
#                 █   █  █▒  █     ▒█  █   █   █     █░    
#                 █▓ ▓█  █░ ▓█  █░ ▒█  █   █   █     ▓█  ▓ 
#                 █▓██   ▒██▒█  ▒███▒  █   █   █      ▓██▒ 
#                                                  

export PROJECT_HOME=$HOME/Code/
export PATH=$HOME/.local/bin:$PATH
export RANGER_LOAD_DEFAULT_RC=FALSE
export LD_PRELOAD=/usr/lib/libharfbuzz.so.0
export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
export VISUAL=vim
export EDITOR=vim
export BROWSER=firefox
export TERM="rxvt-unicode-256color"
export TZ=Africa/Nairobi
export LFS=/mnt/lfs

source virtualenvwrapper.sh
source ~/.git-prompt.sh
source "$HOME/.vim/bundle/gruvbox/gruvbox_256palette.sh"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


#-----------------------------------------------------------------------
#
#                           PROMPT
#-----------------------------------------------------------------------

# Syntactic sugar for ANSI escape sequences
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

#PS1='\[\e[1;37m\]┌─\e[0m\e[34m[\[\e[0m\e[0;33m\] \w\[\e[0m\] \e[34m]\e[0m $(__git_ps1 "\[\e[0;31m\]@\[\e[0m\]\[\e[1;32m\]\[\e[5m \]%s\[\e[25m\]\[\e[0m\]")\n└─>\[\e[0m\] '
PS1='\[\e[0;31m\]────── \[\e[0;32m\]\W\[\e[0m\] $(__git_ps1 "\[\e[0;33m\]at\[\e[0m\] \[\e[0;34m\]%s\[\e[0m\]") '


#-----------------------------------------------------------------------
#                                           
#                           ALIASES
#-----------------------------------------------------------------------

alias dots='cd ~/Repositories/dotfiles/'
alias i3config='vim ~/.config/i3/config'
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias xresources='vim ~/.Xresources'
alias reload='source ~/.bashrc'
alias htop='htop -u mohabaks'
alias blog='cd ~/Code/Blog/'
alias code='cd ~/Code/DjangoProjects'
alias django='workon DjangoProjects'
alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -hFX'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias rm='rm -i'
alias modem_start='sudo netctl start modem'
alias modem_stop='sudo netctl stop modem'


#-----------------------------------------------------------------------
#
#                      MISC FUNCTIONS
#-----------------------------------------------------------------------



#-----------------------------------------------------------------------
#  
#                      COLORS FOR MAN PAGES 
#-----------------------------------------------------------------------

export LESS_TERMCAP_mb=$'\e[0;31m'
export LESS_TERMCAP_md=$'\e[0;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[0;34;36m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[0;35m'
