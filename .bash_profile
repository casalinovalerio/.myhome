#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}
[[ -f "$CONFIG_DIR/bash/.bashrc" ]] && . "$CONFIG_DIR/bash/.bashrc"
export HISTFILE="$CONFIG_DIR/bash/bash_history"
