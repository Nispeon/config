ZSH=$HOME/.oh-my-zsh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nispeon/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

ZSH_THEME=robbyrussell

plugins=(
  git
  bundler
  dotenv
  macos
  rake
  rbenv
  ruby
)

source $ZSH/oh-my-zsh.sh

neofetch

alias ga="git add ."
alias dcu="docker compose up"
alias gst="git status"
alias gd="git diff"
alias glg="git log"
alias gs="git checkout"
alias hg="history | grep"
alias sail="./vendor/bin/sail"
alias vps="echo ssh ubuntu@xx.xxx.xxx.x go look for the ip on your provider ^^"

#compdef castor

# This file is part of the Symfony package.
#
# (c) Fabien Potencier <fabien@symfony.com>
#
# For the full copyright and license information, please view
# https://symfony.com/doc/current/contributing/code/license.html

#
# zsh completions for castor
#
# References:
#   - https://github.com/spf13/cobra/blob/master/zsh_completions.go
#   - https://github.com/symfony/symfony/blob/5.4/src/Symfony/Component/Console/Resources/completion.bash
#
_sf_castor() {
    local lastParam flagPrefix requestComp out comp
    local -a completions

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}") lastParam=${words[-1]}

    # For zsh, when completing a flag with an = (e.g., castor -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[0]} ${words[1]} _complete --no-interaction -szsh -a1 -c$((CURRENT-1))" i=""
    for w in ${words[@]}; do
        w=$(printf -- '%b' "$w")
        # remove quotes from typed values
        quote="${w:0:1}"
        if [ "$quote" = \' ]; then
            w="${w%\'}"
            w="${w#\'}"
        elif [ "$quote" = \" ]; then
            w="${w%\"}"
            w="${w#\"}"
        fi
        # empty values are ignored
        if [ ! -z "$w" ]; then
            i="${i}-i${w} "
        fi
    done

    # Ensure at least 1 input
    if [ "${i}" = "" ]; then
        requestComp="${requestComp} -i\" \""
    else
        requestComp="${requestComp} ${i}"
    fi

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)

    while IFS='\n' read -r comp; do
        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}
            local tab=$(printf '\t')
            comp=${comp//$tab/:}
            completions+=${comp}
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Let inbuilt _describe handle completions
    eval _describe "completions" completions $flagPrefix
    return $?
}

compdef _sf_castor castor

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
