# More info: http://zsh.sourceforge.net/Doc/Release/Options.html
setopt menu_complete     # When ambiguous completion fill 1st match, then others
setopt histignorealldups # Don't save duplicates in history
setopt autocd            # Type a dir and cd is automatically added 
setopt autopushd         # cd automatically push
setopt recexact          # If string matches one completion, it is accepted
setopt nobgnice          # Background jobs not limited at lower priority
setopt longlistjobs      # Job notifications in long format
setopt appendhistory     # Append history instead of overwriting
### Set variables
#################
HISTFILE="$ZCACHEDIR/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
[ -d "$ZCUSTOMCOMPLETION" ] && fpath+="$ZCUSTOMCOMPLETION"
[ -d "$HOME/scripts" ] && PATH="$HOME/scripts/sh:$PATH"
[ -d "/opt/bin" ] && PATH="/opt/bin:$PATH"
PATH="/usr/local/bin:/usr/local/sbin/:$PATH"
### Plugins
##################
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
### Completion Settings
#######################
source "$ZDOTDIR/conf.d/completion.zsh"
### Bind keys
#############
source "$ZDOTDIR/conf.d/bindings.zsh"
### Set alias
#############
source "$ZDOTDIR/conf.d/aliases.zsh"
### Set functions
########################
source "$ZDOTDIR/conf.d/functions.zsh"
### Prompt
###########
source "$ZDOTDIR/conf.d/prompt.zsh"
