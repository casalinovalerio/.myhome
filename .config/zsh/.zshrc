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
function myhome_submodules_update() {
  local _list=$( grep "path" "$HOME/.gitmodules" | cut -d"=" -f2 | tr -d ' ' )
  while IFS= read -r _path; do
    git --git-dir="${HOME}/${_path}/.git" pull origin master; 
  done <<< "$_list"
  git --git-dir="$HOME/.myhome/" --work-tree="$HOME" add $( tr '\n' ' ' <<< "$_list" )
  git --git-dir="$HOME/.myhome/" --work-tree="$HOME" commit -m "Updated submod"
  git --git-dir="$HOME/.myhome/" --work-tree="$HOME" push origin master
}

### Theming
###########
autoload -Uz compinit colors zcalc add-zsh-hook vcs_info
compinit -d
colors
setopt prompt_subst
zstyle ":vcs_info:git:*" formats "%{$fg[magenta]%}%r/%S (%{$fg_bold[yellow]%}%b%{$fg[magenta]%})%{$reset_color%}"

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

function _v2() {
    vcs_info
    [ -n "$vcs_info_msg_0_" ] && psvar[2]="${vcs_info_msg_0_}$(parse_git_state)" && return 0
    psvar[2]="%{$fg[cyan]%}%3~%{$reset_color%}"
}

function _timer_start() { _timer="$SECONDS"; }
function _v3() { 
    psvar[3]=""
    [ -z "$_timer" ] && return 0
    local _elapsed="$((SECONDS - _timer))"
    [ "$_elapsed" -lt "$_MY_TIMER_THRESHOLD" ] && psvar[3]="" && return 0
    psvar[3]="took %{$fg[magenta]%}$(date -d @$_elapsed -u +%Hh%Mm%Ss)%{$reset_color%}"
    unset _timer
}

psvar[1]="%(!.%{$fg[red]%}%n.%{$fg[yellow]%}%n)%{$reset_color%} in"
psvar[2]="%{$fg[cyan]%}%3~%{$reset_color%}"
psvar[3]=""
psvar[4]="%(?.%{$fg[green]%}>>.%{$fg[red]%}>>)%{$reset_color%} "

add-zsh-hook precmd _v2
add-zsh-hook preexec _timer_start
add-zsh-hook precmd _v3

PROMPT="\${psvar[@]}"
RPROMPT="%(?..%{$fg[red]%}%?)%{$reset_color%}"
