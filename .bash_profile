#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc && exit 0

CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}
[[ -f "$CONFIG_DIR/bash/.bashrc" ]] && . "$CONFIG_DIR/bash/.bashrc"
