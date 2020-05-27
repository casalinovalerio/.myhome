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
_MY_TIMER_THRESHOLD=5

[ -d "$ZSH_CUSTOM_COMPLETION_PATH" ] && fpath+="$ZSH_CUSTOM_COMPLETION_PATH"

# Custom bin paths
[ -d "$HOME/scripts" ] && PATH="$HOME/scripts/sh:$PATH"
[ -d "/opt/bin" ] && PATH="/opt/bin:$PATH"
PATH="/usr/local/bin:/usr/local/sbin/:$PATH"

### Source plugins
##################
source "$CONFIG_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$CONFIG_DIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$CONFIG_DIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

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
bindkey '^[[5~'   history-beginning-search-backward
bindkey '^[[6~'   history-beginning-search-forward
# Other functionalities
bindkey "\e[1;5D" backward-word                        
bindkey "\e[1;5C" forward-word
bindkey '^H'      backward-kill-word # ctrl+backspace to kill word
bindkey '^[[Z'    undo # Shift+tab to undo
bindkey ' '       magic-space    
bindkey '^I'      complete-word 
# History substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up                      
bindkey '^[[B' history-substring-search-down

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
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
function makezip() { zip -r "${1%%/}.zip" "$1" ; }
function setgovernor() {
  [ -z "$1" ] && return 1
  [ "$1" != "conservative" ] && [ "$1" != "performance" ] && return 1 
  echo "$1" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
}
function url_encode() { 
  python3 -c "import urllib.parse; print(urllib.parse.quote(input()))" <<< "$1"
}

### Theming
###########
autoload -U compinit colors zcalc
compinit -d
colors
setopt prompt_subst

# Git status
GIT_PROMPT_PREFIX="%{$fg[magenta]%}[%{$reset_color%}"       # prefix
GIT_PROMPT_SUFFIX="%{$fg[magenta]%}]%{$reset_color%}"       # suffix
GIT_PROMPT_AHEAD="%{$fg[green]%}+NUM%{$reset_color%}"       # ahead by "NUM"
GIT_PROMPT_BEHIND="%{$fg[green]%}-NUM%{$reset_color%}"      # behind by "NUM"
GIT_PROMPT_MERGING="%{$fg_bold[red]%}X%{$reset_color%}"     # merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}?%{$reset_color%}"   # untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}M%{$reset_color%}" # modified files
GIT_PROMPT_STAGED="%{$fg_bold[yellow]%}!%{$reset_color%}"   # staged changes

function parse_git_state() {
    local GIT_STATE=""
    local N_A="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    local N_B="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    local GIT_UNT="$(git ls-files --other --exclude-standard 2> /dev/null)"
    [ "$N_A" -gt 0 ] && GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$N_A}
    [ "$N_B" -gt 0 ] && GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$N_B}
    [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD && GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
    [ "$GIT_UNT" != "" ] && GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    git diff --quiet 2> /dev/null || GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    git diff --cached --quiet 2> /dev/null || GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    [ -n $GIT_STATE ] && echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
}

function _pwd_prompt_string() {
    local git_where="$( ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2>/dev/null)"
    if [ -n "$git_where" ]; then
        git_where="%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}"
        local toplevel="$(git rev-parse --show-toplevel | xargs basename)"
        local relative="$(git rev-parse --show-prefix)"
        local relative_path="%{$fg[magenta]%}$toplevel/$relative"
        local git_prompt="$GIT_PROMPT_PREFIX$git_where$GIT_PROMPT_SUFFIX"
        psvar[1]="$relative_path $(parse_git_state)$git_prompt" 
        return 0
    fi
    psvar[1]="%{$fg[cyan]%}%3~%{$reset_color%}"
}

function my_timer_start() { export SECONDS=0; psvar[3]="$1"; }
function my_timer_show() {  
    local prefix=" took %{$fg[magenta]%}"
    local suffix="%{$reset_color%}"
    psvar[2]=( "" )
    [ $SECONDS -lt $_MY_TIMER_THRESHOLD ] && return 0
    
    if [ $SECONDS -lt 60 ];then
        psvar[2]=( "${prefix}${SECONDS}s${suffix}")
        return 0
    fi
    if [ $SECONDS -lt 3600 ]; then
        psvar[2]=( "${prefix}$(date -d @$SECONDS -u +%Mm%Ss)${suffix}" )
        return 0
    fi
    psvar[2]=( "${prefix}$(date -d @$SECONDS -u +%Hh%Mm%Ss)${suffix}" )
}

function prompt() {
    local usr="%(!.%{$fg[red]%}%n.%{$fg[yellow]%}%n)%{$reset_color%}"
    local st="%(?.%{$fg[green]%}>>.%{$fg[red]%}>>)%{$reset_color%}"
    [ -n "${psvar[3]}" ] && my_timer_show
    PROMPT="$usr in ${psvar[1]}${psvar[2]} $st "
}
RPROMPT="%(?..%{$fg[red]%}%?)%{$reset_color%}"

chpwd_functions+=( _pwd_prompt_string )
preexec_functions+=( my_timer_start )
precmd_functions+=( prompt )
