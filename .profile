### Freedesktop environmental variables
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
XDG_CACHE_HOME="$HOME/.cache"

### Default programs
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="chromium"
export READER="zathura"

### Stay away from my home
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/.gtkrc-2.0"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export LESSHISTFILE="$XDG_CACHE_HOME/less/histfile"

### zsh variables
export ZCACHEDIR="$XDG_CACHE_HOME/zsh"
export ZCUSTOMCOMPLETION="$ZDOTDIR/completion"
