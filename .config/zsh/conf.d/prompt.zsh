autoload -Uz compinit colors zcalc add-zsh-hook vcs_info
compinit -d
colors
setopt prompt_subst
zstyle ":vcs_info:git:*" formats "%{$fg[magenta]%}%r/%S (%{$fg_bold[yellow]%}%b%{$fg[magenta]%})"

# Git status
GIT_PROMPT_PREFIX="%{$fg[magenta]%}["       # prefix
GIT_PROMPT_SUFFIX="%{$fg[magenta]%}]"       # suffix
GIT_PROMPT_AHEAD="%{$fg[green]%}+NUM"       # ahead by "NUM"
GIT_PROMPT_BEHIND="%{$fg[green]%}-NUM"      # behind by "NUM"
GIT_PROMPT_MERGING="%{$fg_bold[red]%}X"     # merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}?"   # untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}M" # modified files
GIT_PROMPT_STAGED="%{$fg_bold[yellow]%}!"   # staged changes

function _git() {
    local _out=""
    local N_A="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    local N_B="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    local GIT_UNT="$(git ls-files --other --exclude-standard 2> /dev/null)"
    [ "$N_A" -gt 0 ] && _out=$_out${GIT_PROMPT_AHEAD//NUM/$N_A}
    [ "$N_B" -gt 0 ] && _out=$_out${GIT_PROMPT_BEHIND//NUM/$N_B}
    [ "$GIT_UNT" != "" ] && _out=$_out$GIT_PROMPT_UNTRACKED
    git diff --quiet 2> /dev/null || _out=$_out$GIT_PROMPT_MODIFIED
    git diff --cached --quiet 2> /dev/null || _out=$_out$GIT_PROMPT_STAGED
    [ -n $_out ] && echo "$GIT_PROMPT_PREFIX$_out$GIT_PROMPT_SUFFIX%{$reset_color%}"
}

function _pwd() {
    vcs_info
    [ -n "$vcs_info_msg_0_" ] && echo -n "${vcs_info_msg_0_/\/. / }$(_git) " && return 0
    echo -n "%{$fg[cyan]%}%3~ "
}

function _vpn() {
    ip a \
        | grep -e "inet.*tun" \
        | sed "s/.*inet //g;s/\/[0-9]\{1,2\}.*//g" \
        | xargs -I '{}' echo " %{$fg[yellow]%}[{}] "
}

_status="%(!.%{$fg[magenta]%}>.%{$fg[yellow]%}>)%(?.%{$fg[green]%}>>.%{$fg[red]%}>>)"

PROMPT="\$(_pwd)\$(_vpn)$_status%{$reset_color%} "
RPROMPT="%(?..%{$fg[red]%}[%?])%{$reset_color%}"
