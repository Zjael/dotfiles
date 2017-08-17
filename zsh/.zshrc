source ~/.zplug/init.zsh

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt append_history # Don't overwrite, append!
setopt INC_APPEND_HISTORY # Write after each command
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_fcntl_lock # use OS file locking
setopt hist_ignore_all_dups # Delete old recorded entry if new entry is a duplicate.
setopt hist_lex_words # better word splitting, but more CPU heavy
setopt hist_reduce_blanks # Remove superfluous blanks before recording entry.
setopt hist_save_no_dups # Don't write duplicate entries in the history file.
setopt share_history # share history between multiple shells
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.

export BROWSER="firefox"
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="micro"
else
  export EDITOR="VSC"
fi

alias update="sudo pacman -Syu && pacaur -Syu"
alias please="sudo !!"
alias fetch="neofetch"
alias colors="./colors.sh"
alias dots='cd ~/dotfiles/'
alias config='cd ~/.config/'
alias ls="ls --color -Fa"
alias ll="ls --color -lha"
alias zshrc="$EDITOR ~/.zshrc"
alias xresources="$EDITOR ~/.Xresources"
eval $(thefuck --alias FUCK)
alias weather="curl wttr.in/Snedsted"
alias ipinfo="curl ipinfo.io/ip"
mkcd() {
  mkdir -p "$1"
  cd "$1"
}
transfer() { # transfer.sh
  # write to output to tmpfile because of progress bar
  tmpfile=$( mktemp -t transferXXX )
  curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
  cat $tmpfile;
  rm -f $tmpfile;
} # alias transfer=transfer
cheat() { # transfer.sh
  curl cheat.sh/$1
} # alias cheat=cheat


zplug "mafredri/zsh-async"
zplug "zsh-users/zsh-autosuggestions"
if zplug check zsh-users/zsh-autosuggestions; then
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down) 
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
fi
zplug "zsh-users/zsh-history-substring-search"
if zplug check zsh-users/zsh-history-substring-search; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi
zplug "zsh-users/zsh-syntax-highlighting"
zplug "rupa/z", use:z.sh
zplug "tarrasch/zsh-autoenv"
zplug "djui/alias-tips"

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git-extras", from:oh-my-zsh
zplug "plugins/git-flow", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh

zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose