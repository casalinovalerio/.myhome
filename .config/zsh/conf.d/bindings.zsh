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
