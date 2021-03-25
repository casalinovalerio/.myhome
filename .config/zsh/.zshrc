# ~/.config/zsh/.zshrc
# This config file is provided by 5amu (https://github.com/5amu)
# and it is a collection of my configurations, specific to my
# workflow. Feel free to customise it for your needs, repackage
# it, including a mention to my work, more specifically, at least
# my GitHub username and the repo https://github.com/5amu/.myhome
# Thanks, and enjoy... :)

### Set options
### http://zsh.sourceforge.net/Doc/Release/Options.html
#######################################################

# If a command is issued that can’t be executed as a normal command, 
# and the command is the name of a directory, perform the cd command 
# to that directory. This option is only applicable if the option 
# SHIN_STDIN is set, i.e. if commands are being read from standard input. 
# The option is designed for interactive use; it is recommended that cd 
# be used explicitly in scripts to avoid ambiguity.
setopt autocd

# Make cd push the old directory onto the directory stack.
setopt autopushd

# If this is set, zsh sessions will append their history list to the 
# history file, rather than replace it. Thus, multiple parallel zsh sessions 
# will all have the new entries from their history lists added to the history 
# file, in the order that they exit. The file will still be periodically 
# re-written to trim it when the number of lines grows 20% beyond the value 
# specified by $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
setopt appendhistory

# On an ambiguous completion, instead of listing possibilities or beeping, 
# insert the first match immediately. Then when completion is requested 
# again, remove the first match and insert the second match, etc. When there
# are no more matches, go back to the first one again. reverse-menu-complete 
# may be used to loop through the list in the other direction. This option 
# overrides AUTO_MENU.
setopt menu_complete

# If a new command line being added to the history list duplicates an 
# older one, the older command is removed from the list (even if it is not 
# the previous event).
setopt histignorealldups

# If the string on the command line exactly matches one of the possible 
# completions, it is accepted, even if there is another completion (i.e. 
# that string with something else added) that also matches.
setopt recexact

# Run all background jobs at a lower priority. This option is set by default.
# DISABLED BY "NO"
setopt nobgnice

# Print job notifications in the long format by default.
setopt longlistjobs

# If set, parameter expansion, command substitution and arithmetic 
# expansion are performed in prompts. Substitutions within prompts do not 
# affect the command status.
setopt prompt_subst

# This option both imports new commands from the history file, and also
# causes your typed commands to be appended to the history file (the latter
# is like specifying INC_APPEND_HISTORY, which should be turned off if this
# option is in effect). The history lines are also output with timestamps
# ala EXTENDED_HISTORY (which makes it easier to find the spot where we
# left off reading the file after it gets re-written).
# By default, history movement commands visit the imported lines as
# well as the local lines, but you can toggle this on and off with the
# set-local-history zle binding. It is also possible to create a zle
# widget that will make some commands ignore imported commands, and some
# include them.
# If you find that you want more control over when commands get
# imported, you may wish to turn SHARE_HISTORY off, INC_APPEND_HISTORY or
# INC_APPEND_HISTORY_TIME (see above) on, and then manually import commands
# whenever you need them using ‘fc -RI’.
setopt share_history

### Set variables
#################
HISTFILE="$ZCACHEDIR/.zhistory"
HISTSIZE=5000
SAVEHIST=5000

### Load options
################
autoload -Uz compinit 
autoload -Uz colors 
autoload -Uz edit-command-line 
compinit -d  && colors
zle -N edit-command-line
zmodload zsh/terminfo

### Plugins
###########
if [ -f "$ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ];
then
    source "$ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[path]=underline
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[command-substitution]=none
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[process-substitution]=none
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
    ZSH_HIGHLIGHT_STYLES[named-fd]=none
    ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
    ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
fi
if [ -f "$ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ];
then
    source "$ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#c1a9c5,bg=gray,bold,underline"
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi
if [ -f "$ZPLUGINDIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ];
then
    source "$ZPLUGINDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
    bindkey '^[[A'             history-substring-search-up
    bindkey '^[[B'             history-substring-search-down
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
fi
if [ -f "$ZPLUGINDIR/minimal-prompt/minimal-prompt.zsh" ];
then
    source "$ZPLUGINDIR/minimal-prompt/minimal-prompt.zsh"
fi

### Completion Settings
### http://zsh.sourceforge.net/Doc/Release/Completion-System.html
####################### 
# General completion settings
zstyle ':completion:*' accept-exact  '*(N)'
zstyle ':completion:*' matcher-list  'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' select-prompt '%SScrolling active: %p%s'
# Using cache
zstyle ':completion:*:complete:*' use-cache  on
zstyle ':completion:*:complete:*' cache-path "$ZCACHEDIR"
# Messages formats
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages'     format '%d'
zstyle ':completion:*:warnings'     format 'No match for: %d'
# Use case specific completion functions
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'


### Bind keys
### http://zsh.sourceforge.net/Doc/Release/Completion-System.html
#############
bindkey -e
bindkey "^X^E"    edit-command-line
bindkey '^[[7~'   beginning-of-line
bindkey '^[[H'    beginning-of-line
bindkey '^[[8~'   end-of-line
bindkey '^[[F'    end-of-line
bindkey "^?"      backward-delete-char
bindkey "\e[3~"   delete-char
bindkey '^[[2~'   overwrite-mode
bindkey '^[[5~'   history-beginning-search-backward
bindkey '^[[6~'   history-beginning-search-forward
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
bindkey '^H'      backward-kill-word 
bindkey '^[[Z'    undo 
bindkey ' '       magic-space
bindkey '^I'      complete-word

### Colored less
################
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

### Set alias
#############
alias cls="clear"
alias ..="cd .."
alias cd..="cd .."
alias ll="ls -lisa --color=auto"
alias ls="ls -CF --color=auto"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias grep='grep --color=auto'
alias open="xdg-open"
alias myhome="/usr/bin/git --git-dir=$HOME/.myhome/ --work-tree=$HOME"

### Set functions
#################
function setgovernor() 
{
  [ -z "$1" ] && return 1
  [ "$1" != "conservative" ] && [ "$1" != "performance" ] && return 1
  echo "$1" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
}

function url_encode() 
{
  python3 -c "import urllib.parse; print(urllib.parse.quote(input()))" <<< "$1"
}

function rfc() 
{
    curl -s --fail "https://tools.ietf.org/rfc/rfc${1}.txt" | less
}

function swap-history()         
{
    local TMPFILE=$( mktemp )
    mv "$ZCACHEDIR/.zhistory" $TMPFILE 
    mv "$ZCACHEDIR/.zhistory.bak" "$ZCACHEDIR/.zhistory" 
    mv $TMPFILE "$ZCACHEDIR/.zhistory.bak"
}

function greetings()
{
	local greet=()
	greet+=("I use Arch BTW")
	greet+=("Arch Chad")
	greet+=("Arch Master Race")
	greet+=("No Ubuntu peasant")
    printf "=%.0s" {1..$(tput cols)}; echo
    printf "=%.0s" {1..$(tput cols)}; echo
    if command -v figlet 1>/dev/null 2>&1
    then
		echo $(shuf -n 1 -e ${greet[@]}) | figlet -c -f smslant
	else
		echo $(shuf -n 1 -e ${greet[@]})
	fi
    printf "=%.0s" {1..$(tput cols)}; echo
    printf "=%.0s" {1..$(tput cols)}; echo
}

### Greet
#########
if command -v lolcat 1>/dev/null 2>&1
then
	greetings | lolcat 2>/dev/null
else
	greetings
fi
