# Freedesktop environmental variables
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
XDG_CACHE_HOME="$HOME/.cache"

# Use vim, nano as fallback
command -v nvim >/dev/null && export EDITOR=/usr/bin/nvim || export EDITOR=/usr/bin/nano

# Change .zshrc to config home
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Some other stuff
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$XDG_CONFIG_HOME/.gtkrc-2.0"
export LESSHISTFILE="$XDG_CACHE_HOME/less/histfile"
export _ZSHRCGITREMOTE="off"
