#
# ~/.bashrc
#

# env variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CASHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_STATE_HOME="$HOME/.local/state"

export GOPATH="$XDG_DATA_HOME/go"
export EDITOR="/usr/bin/vim"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1="\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;36m\]\h \[\e[1;35m\]\W \[\e[0m\]$ "
. "$HOME/.cargo/env"

HISTCONTROL=ignoredups



set -o vi
alias ls='exa'
alias make="make -j$(python3 -c "import os; print(os.cpu_count())")"
alias vi='vim'

which powerline-shell 2> /dev/null
if [[ $? -eq 0 ]] ; then

    function _update_ps1() {
        # PS1="$(powerline-shell $? | sed 's//?\\[??\\]/g' | sed 's/✎/?\\[??\\]/g')"
        PS1="$(powerline-shell $?)"
    }

    if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
        PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi

    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /usr/share/powerline/bindings/bash/powerline.sh

fi
