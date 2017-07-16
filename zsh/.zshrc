#-------------#
#-- ANTIGEN --#
#-------------#
source /path-to-antigen-clone/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle heroku
antigen bundle pip
# antigen bundle lein
antigen bundle command-not-found
antigen bundle autojump
antigen bundle dircycle
antigen bundle common-aliases
antigen bundle compleat
antigen bundle npm
antigen bundle web-search
antigen-bundle vagrant
antigen-bundle asdf

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh
antigen bundle Tarrasch/zsh-autoenv
antigen bundle djui/alias-tips

# Load the theme.
# antigen bundle tylerreckart/hyperzsh
antigen bundle sindresorhus/pure

# Tell Antigen that you're done.
antigen apply

#-------------------#
#-- ZSH Variables --#
#-------------------#
export BROWSER="firefox"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='micro'
else
  export EDITOR='VSC'
fi

#-----------------#
#-- ZSH Aliases --#
#-----------------#
alias update='sudo pacman -Syu && pacaur -Syu'
alias please='sudo !!'
alias fetch="neofetch"

alias colors="./colors.sh"
alias ls="ls --color -Fa"
alias ll="ls --color -lha"

alias zshrc="$EDITOR ~/.zshrc"
alias xresources="$EDITOR ~/.Xresources"

eval $(thefuck --alias FUCK)

mkcd() {
    mkdir -p "$1"
    cd "$1"
}

#-----------------#
#-- ZSH History --#
#-----------------#
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000