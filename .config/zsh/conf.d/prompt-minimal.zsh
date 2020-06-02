autoload -Uz compinit colors zcalc vcs_info
compinit -d
colors
setopt prompt_subst
zstyle ":vcs_info:git:*" formats "%{$fg[magenta]%}%r/%S (%{$fg_bold[yellow]%}%b%{$fg[magenta]%})"

function _pwd() {
    vcs_info 
    [ -n "$vcs_info_msg_0_" ] && echo "${vcs_info_msg_0_/\/. / }" && return 0
    echo "%{$fg[cyan]%}%3~%{$reset_color%}"
}

PROMPT=" \$(_pwd) %(!.%{$fg[magenta]%}>.%{$fg[yellow]%}>)%(?.%{$fg[green]%}>.%{$fg[red]%}>)%{$reset_color%} "
RPROMPT="%(?..%{$fg[red]%}[%?])%{$reset_color%}"
