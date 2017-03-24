# ~/.zshrc 
# Puredyne zsh config

# misc
setopt nohup # Don't kill jobs when logout

# theme -------------------------------------------------------------
# prompt
PS1=$'%{\e[1;36m%}(%{\e[34m%}%30<..<%~%{\e[36m%}) %{\e[36m%}%#%b$(git_super_status) %{\e[0m%}'
if [ "`id -u`" -eq 0 ]; then
export RPS1=$'%{\e[37m%}%{\e[1;30m%}%{\e[7m%} %M %{\e[0m%}'
else
export RPS1=$'%{\e[37m%}%{\e[1;30m%} %M %{\e[0m%}'
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}" 

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN="" 

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"


# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info) ]]; then
            echo "%{$fg[magenta]%}detached-head%{$reset_color%})"
        else
            echo "$(git_prompt_info)"
        fi
    fi
}

# Determine if we are using a gemset.
function rvm_gemset() {
    if hash rvm 2>/dev/null; then
        GEMSET=`rvm gemset list | grep '=>' | cut -b4-`
        if [[ -n $GEMSET ]]; then
            echo "%{$fg[yellow]%}$GEMSET%{$reset_color%}|"
        fi 
    fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))
           
            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))
            
            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "($(rvm_gemset)$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "($(rvm_gemset)$COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
            else
                echo "($(rvm_gemset)$COLOR${MINUTES}m%{$reset_color%}|"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "($(rvm_gemset)$COLOR~|"
        fi
    fi
}




source ~/zsh-git-prompt/zshrc.sh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 
### RVM
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
# colors
eval `dircolors -b /etc/.dircolors`



# completion --------------------------------------------------------
zstyle ':completion:*' menu select=1  # completion menu
# ssh host completion
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
[ -f ~/.ssh/known_hosts ] && : ${(A)ssh_known_hosts:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}}
zstyle ':completion:*:*:*' hosts $ssh_config_hosts $ssh_known_hosts

unsetopt list_ambiguous         # prompt after 1st tab
setopt glob_dots                # completion for dot files

# bells -------------------------------------------------------------
unsetopt beep		# no beep
unsetopt hist_beep	# no beep
unsetopt list_beep	# no beep

# aliases -----------------------------------------------------------
# ls stuff
alias  hard= 'mount -t vfat -o umask=000 /dev/sda1 /media/disk'

alias ls='ls --classify --color=auto --human-readable --time-style=locale'
alias l='ls'
alias ll='ls -l'
alias la='ls -a --classify --color=always '
alias lla='ls -la --classify --color=always -l --human-readable |less -R'
alias lsa='ls -ld .*'
alias lsd='ls -ld *(-/DN)'
# handy 
alias df='df  --human-readable'
alias du='du  --human-readable '
alias grep='grep --color'
alias cd='cd'
alias pythonbook='cd /home/egelor/Apps/eGelor_Programming/BOOK/Python/Python_TCSE3-3rd-examples/src/py/intro'
alias books='cd /home/egelor/Apps/eGelor_Programming/BOOKS'
alias ofxOpenCv='cd /home/egelor/Apps/eGelor_Programming/ofxOpenCv'
alias Emacs_Projects='/home/egelor/Apps/eGelor_Programming/Emacs_Projects'
alias Unix='home/egelor/Apps/eGelor_Programming/Unix'
alias apt='sudo apt-get install'
alias opencv_eng_folder='cd /usr/local/share/opencv'
alias opencv_Ap_folder='cd /home/egelor/Apps/OpenCV-2/OpenCV-2.3.0'
alias opencvcompile=' gcc `pkg-config --cflags opencv` `pkg-config --libs opencv` -o '
alias interfaces='sudo nano /etc/network/interfaces'
# Convert ogv to flv.
# Usage: ogv2flv input.ogv -o output.flv
# add -audiofile yoursound.wav if you need to replace the soundtrack
alias ogv2flv='mencoder -of lavf -oac mp3lame -lameopts abr:br=56 -srate 22050 -ovc lavc -lavcopts vcodec=flv:vbitrate=250:mbd=2:mv0:trell:v4mv:cbp:last_pred=3 -vf scale=640:480'
# various -----------------------------------------------------------
unsetopt ignore_eof 	# Ctrl+D acts like a 'logout'
setopt print_exit_value # print exit code if different from '0'
unsetopt rm_star_silent # confirmation asked for 'rm *'

# buddies -----------------------------------------------------------
watch=(notme)                   	# watch for everybody but me
LOGCHECK=300                    	# check activity every 5 min
WATCHFMT='%n %a %l from %m at %t.'	# watch display
# EMAIL -------------------------------------------------------------
export EMAIL="e.trifonidis@gmail.com"
export NAME="Eugene Tryfonides"
# history -----------------------------------------------------------
export HISTORY=1600
export SAVEHIST=1600
export HISTFILE=$HOME/.history
setopt hist_verify		# prompt before execution


# colorful manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;37m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export LESS='-R'
export LESSOPEN='|pygmentize -g  %s'

# -------------------------------------------------------------------
autoload -U compinit 
compinit

#Python ege

export scripting=$HOME/scripting
export PYTHONAPATH=$scripting/src/tools
PATH=$PATH:$scripting/src/tools
#linux brew
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"
export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
