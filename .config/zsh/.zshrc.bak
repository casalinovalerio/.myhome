export TERM="xterm-256color"

setopt menu_complete inc_append_history autocd recexact longlistjobs
setopt histignorealldups autopushd nobgnice autoparamslash

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

### Set variables
#################
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
HISTFILE="$CONFIG_DIR/.zhistory"
HISTSIZE=1000
SAVEHIST=1000

# Custom bin paths
[ -d "$HOME/scripts" ] && PATH="$HOME/scripts/sh:$PATH"
[ -d "/opt/bin" ] && PATH="/opt/bin:$PATH"
PATH="/usr/local/bin:/usr/local/sbin/:$PATH"

# Custom locations
ZSH_CUSTOM_COMPLETION_PATH="$CONFIG_DIR/custom/completion/"

### Load colors
###############
autoload colors zsh/terminfo
[ "$terminfo[colors]" -ge 8 ] && colors
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
done

### set common functions
########################
function url_encode() { python3 -c "import urllib.parse; print(urllib.parse.quote(input()))" <<< "$1"; }
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
function makezip() { zip -r "${1%%/}.zip" "$1" ; }
function zsh-toogle-gitremote() {
    [ -z $_ZSHRCGITREMOTE ] && export _ZSHRCGITREMOTE=off && return 0
    [ $_ZSHRCGITREMOTE = off ] && export _ZSHRCGITREMOTE=on || export _ZSHRCGITREMOTE=off
}

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
alias vibindings="bindkey -v"
alias embindings="bindkey -e"
alias myhome="/usr/bin/git --git-dir=$HOME/.myhome/ --work-tree=$HOME"

### Add custom completions
##########################
[ -d "$ZSH_CUSTOM_COMPLETION_PATH" ] && fpath+="$ZSH_CUSTOM_COMPLETION_PATH"

### Bind keys
#############
autoload -U compinit
compinit
bindkey -e
bindkey "^?"      backward-delete-char
bindkey "\e[3~"   delete-char
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
bindkey '^[OH'    beginning-of-line
bindkey '^[OF'    end-of-line
bindkey '^[[5~'   up-line-or-history
bindkey '^[[6~'   down-line-or-history
bindkey "^[[A"    history-beginning-search-backward-end
bindkey "^[[B"    history-beginning-search-forward-end
bindkey "^r"      history-incremental-search-backward
bindkey ' '       magic-space    
bindkey '^I'      complete-word 

### Completion Settings
#######################
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$CONFIG_DIR/cache/$HOST"
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

### Completion Styles
#####################
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( 2 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'

# zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

### Source plugins
##################
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

### Prompt configuration
########################
autoload -Uz vcs_info
setopt prompt_subst 

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '!'
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-untracked git-modified
zstyle ':vcs_info:*' formats '%F{5}%r/%S%f %F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%c%m%f '

function +vi-git-st() {
    { [ -z "$_ZSHRCGITREMOTE" ] || [ "$_ZSHRCGITREMOTE" = "off" ]; } && return 0
    local ahead behind
    local -a gitstatus
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "+${ahead}" )
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "-${behind}" )
    hook_com[misc]+="${(j:/:)gitstatus}"
}

my_vcs_info() { vcs_info && psvar[1]=( "$vcs_info_msg_0_" ) }
my_timer_start() { timer_start=$( date +%s ); }
my_timer_show() { 
    local elapsed hours minutes seconds
    psvar[2]=( "" )
    [ -n $timer_start ] && elapsed=$(( $(date +%s) - ${timer_start:-$( date +%s )} )) || return 0
    [ $elapsed -lt 3 ] && return 0
    [ $elapsed -lt 60 ] && psvar[2]=( "${elapsed}s") && return 0
    seconds=$(($elapsed%60))
    minutes=$(($elapsed/60))
    [ $elapsed -lt 3600 ] && psvar[2]=( "${minutes}m${seconds}s" ) && return 0
    hours=$(($minutes/60))
    minutes=$(($minutes%60))
    psvar[2]=( "${hours}h${minutes}m${seconds}s" )
}

function +vi-git-untracked() { git status -s | grep '^??' >/dev/null && hook_com[staged]+='?'; }
function +vi-git-modified() { git status -s | grep "^\s\{1,\}M" >/dev/null && hook_com[staged]+='M'; }

prompt() {
    local usr workdir st errcode elapsed
    usr="%(!.%F{9}%n%f.%F{11}%n%f)"
    workdir="%(1V.${psvar[1]//\./}.%F{6}%3~%f)"
    st="%(?.%F{2}>>%f.%F{9}>>%f)"
    errcode="%(?..%F{9}%?%f)"
    elapsed="%(2V. took %F{13}${psvar[2]}%f.)"

    PROMPT="$usr in ${workdir}${elapsed} $st "
    RPROMPT="$errcode"
}

# Preexec and precmd functions added
preexec_functions+=( my_timer_start )
precmd_functions+=( my_vcs_info )
precmd_functions+=( my_timer_show )
precmd_functions+=( prompt )
