export TERM="xterm-256color"

# More info: http://zsh.sourceforge.net/Doc/Release/Options.html
setopt menu_complete     # When ambiguous completion fill 1st match, then others
setopt histignorealldups # Don't save duplicates in history
setopt autocd            # Type a dir and cd is automatically added 
setopt autopushd         # cd automatically push
setopt recexact          # If string matches one completion, it is accepted
setopt nobgnice          # Background jobs not limited at lower priority
setopt longlistjobs      # Job notifications in long format
setopt appendhistory     # Append history instead of overwriting

### Set variables
#################
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
CACHE_DIR="${XDG_CONFIG_HOME:-$HOME/.cache}/zsh"
ZSH_CUSTOM_COMPLETION_PATH="$CONFIG_DIR/completion"
HISTFILE="$CONFIG_DIR/.zhistory"
HISTSIZE=500
SAVEHIST=500

[ -d "$ZSH_CUSTOM_COMPLETION_PATH" ] && fpath+="$ZSH_CUSTOM_COMPLETION_PATH"

# Custom bin paths
[ -d "$HOME/scripts" ] && PATH="$HOME/scripts/sh:$PATH"
[ -d "/opt/bin" ] && PATH="/opt/bin:$PATH"
PATH="/usr/local/bin:/usr/local/sbin/:$PATH"

### Source plugins
##################
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

### Completion Settings
#######################
# Speed up completion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$CACHE_DIR/$HOST"
# Case insensitive TAB completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Prompt a menu with TAB completion 
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
# formatting and messages
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

### Bind keys
#############
# Set emacs bindings
bindkey -e   
# Home and End keys
bindkey '^[[7~'   beginning-of-line
bindkey '^[[H'    beginning-of-line
bindkey '^[[8~'   end-of-line
bindkey '^[[F'    end-of-line
# Basic functionalities
bindkey "^?"      backward-delete-char 
bindkey "\e[3~"   delete-char
bindkey '^[[2~'   overwrite-mode
bindkey "^[[A"    history-beginning-search-backward
bindkey "^[[B"    history-beginning-search-forward
bindkey '^[[5~'   up-line-or-history
bindkey '^[[6~'   down-line-or-history
# Other functionalities
bindkey "\e[1;5D" backward-word                        
bindkey "\e[1;5C" forward-word
bindkey '^H'      backward-kill-word # ctrl+backspace to kill word
bindkey '^[[Z'    undo # Shift+tab to undo
bindkey ' '       magic-space    
bindkey '^I'      complete-word 

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
########################
function url_encode() { python3 -c "import urllib.parse; print(urllib.parse.quote(input()))" <<< "$1"; }
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

### Theming
###########
autoload -U compinit colors zcalc
compinit -d
colors
setopt prompt_subst

# Git status
GIT_PROMPT_SYMBOL="%{$fg[blue]%}-"                          # clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"         # prefix
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"         # suffix
GIT_PROMPT_AHEAD="%{$fg[red]%}+NUM%{$reset_color%}"         # ahead by "NUM"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}-NUM%{$reset_color%}"       # behind by "NUM"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}X%{$reset_color%}" # merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}?%{$reset_color%}"   # untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}M%{$reset_color%}" # modified files
GIT_PROMPT_STAGED="%{$fg_bold[green]%}!%{$reset_color%}"    # staged changes

parse_git_state() {
local GIT_STATE=""
local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
fi
local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
fi
local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
fi
if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
fi
if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
fi
if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
fi
if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
fi
}

function location_prompt_string() {
    local git_where="$( ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null )"

    [ ! -n "$git_where" ] && echo "%{$fg[cyan]%}%3~" && return 0
    [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}

PROMPT="%(!.%{$fg[red]%}%n.%{$fg[yellow]%}%n)%{$reset_color%} in $( location_prompt_string )%(1V. took %{$fg[magenta]%}${psvar[1]}%{$reset_color%}.) %(?.%{$fg[green]%}>>.%{$fg[red]%}>>)%{$reset_color%} "
RPROMPT="%(?..%{$fg[red]%}%?)%{$reset_color%}"

my_timer_start() { timer_start=$( date +%s ); }
my_timer_show() { 
    local elapsed hours minutes seconds
    psvar[1]=( "" )
    [ -n $timer_start ] && elapsed=$(( $(date +%s) - ${timer_start:-$( date +%s )} )) || return 0
    [ $elapsed -lt 3 ] && return 0
    [ $elapsed -lt 60 ] && psvar[2]=( "${elapsed}s") && return 0
    seconds=$(($elapsed%60))
    minutes=$(($elapsed/60))
    [ $elapsed -lt 3600 ] && psvar[2]=( "${minutes}m${seconds}s" ) && return 0
    hours=$(($minutes/60))
    minutes=$(($minutes%60))
    psvar[1]=( "${hours}h${minutes}m${seconds}s" )
}

preexec_functions+=( my_timer_start )
precmd_functions+=( my_timer_show )
