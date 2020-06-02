_MY_TIMER_THRESHOLD=6
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

PROMPT="\${\${psvar[@]}//  / }"
RPROMPT="%(?..%{$fg[red]%}[%?])%{$reset_color%}"
