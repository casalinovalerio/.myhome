### Set options
### http://zsh.sourceforge.net/Doc/Release/Options.html
############### 
setopt menu_complete histignorealldups autocd autopushd recexact nobgnice 
setopt longlistjobs appendhistory prompt_subst share_history

### Set variables
#################
HISTFILE="$ZCACHEDIR/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

### Load options
################
autoload -Uz compinit colors edit-command-line && compinit -d && colors
zle -N edit-command-line && zmodload zsh/terminfo

### Plugins
##################
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
    bindkey '^[[A'    history-substring-search-up
    bindkey '^[[B'    history-substring-search-down
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
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$CACHE_DIR/$HOST"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
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
alias \
    cls="clear" \
    ..="cd .." \
    cd..="cd .." \
    ll="ls -lisa --color=auto" \
    ls="ls -CF --color=auto" \
    psgrep="ps aux | grep -v grep | grep -i -e VSZ -e" \
    grep='grep --color=auto' \
    open="xdg-open" \
    myhome="/usr/bin/git --git-dir=$HOME/.myhome/ --work-tree=$HOME" \

### Set functions
########################
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

function myhome_submodules_update() 
{
  local _list=$( grep "path" "$HOME/.gitmodules" | cut -d"=" -f2 | tr -d ' ' )
  local _myhome="$HOME/.myhome/"
  while IFS= read -r _path; do
    git --git-dir="${HOME}/${_path}/.git" pull origin master;
  done <<< "$_list"
  git --git-dir="$_myhome" --work-tree="$HOME" add $( tr '\n' ' ' <<< "$_list" )
  git --git-dir="$_myhome" --work-tree="$HOME" commit -m "Updated submod"
  git --git-dir="$_myhome" --work-tree="$HOME" push origin master
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
