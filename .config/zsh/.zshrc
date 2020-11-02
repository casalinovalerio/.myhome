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
[ -d "$ZCUSTOMCOMPLETION" ] && fpath+="$ZCUSTOMCOMPLETION"
[ -d "$HOME/.scripts" ] && PATH="$HOME/.scripts/sh:$PATH"
PATH="/usr/local/bin:/usr/local/sbin/:$PATH"
### Plugins
##################
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$ZDOTDIR/plugins/minimal-prompt/minimal-prompt.zsh"
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
zmodload zsh/terminfo
bindkey -e
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
bindkey '^[[A'    history-substring-search-up
bindkey '^[[B'    history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
### Set alias
#############
alias cls="clear" ..="cd .." cd..="cd .." ll="ls -lisa --color=auto" \
ls="ls -CF --color=auto" psgrep="ps aux | grep -v grep | grep -i -e VSZ -e" \
grep='grep --color=auto' open="xdg-open" \
myhome="/usr/bin/git --git-dir=$HOME/.myhome/ --work-tree=$HOME"
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
  local _myhome="$HOME/.myhome/"
  while IFS= read -r _path; do
    git --git-dir="${HOME}/${_path}/.git" pull origin master;
  done <<< "$_list"
  git --git-dir="$_myhome" --work-tree="$HOME" add $( tr '\n' ' ' <<< "$_list" )
  git --git-dir="$_myhome" --work-tree="$HOME" commit -m "Updated submod"
  git --git-dir="$_myhome" --work-tree="$HOME" push origin master
}
### command-not-found
#####################
# Offer to install missing package if command is not found
if [[ -r /usr/share/zsh/functions/command-not-found.zsh ]]; then
    source /usr/share/zsh/functions/command-not-found.zsh
    export PKGFILE_PROMPT_INSTALL_MISSING=1
fi



