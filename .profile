### Freedesktop environmental variables
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
XDG_CACHE_HOME="$HOME/.cache"

### Default programs
export EDITOR="nvim"
export TERMINAL="terminator"
export BROWSER="brave"
export READER="zathura"

### Stay away from my home
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/.gtkrc-2.0"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export LESSHISTFILE="$XDG_CACHE_HOME/less/histfile"

### zsh variables
export ZCACHEDIR="$XDG_CACHE_HOME/zsh"
export ZPLUGINDIR="/usr/share/zsh/plugins"
export ZCUSTOMCOMPLETION="$ZDOTDIR/completion"

### If on wayland, and with alacritty, we need more. The second check is to
### determine if we are on wayland with loginctl
if [ -z "$WAYLAND_DISPLAY" ]; then
    if loginctl | grep "$USER" | tr -s ' ' | cut -d ' ' -f 2 \
    | xargs -I '{}' loginctl show-session '{}' -p Type | cut -d '=' -f 2 \
    | xargs -I '{}' test "wayland" = '{}'; then        
        TERMINAL="env WAYLAND_DISPLAY= $TERMINAL"
    fi
fi

export VAGRANT_HOME=/opt/vagrant.d
