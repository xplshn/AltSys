#!/bin/sh

# Check if BASHRC_LOADED variable is set
if [ -z "$BASHRC_LOADED" ]; then
    BASHRC_LOADED=true

    ###
    HISTFILE="$HOME/.sh_history"
    ###

    set_prompt() {
        if [ -n "$PS1" ] && [ "$(id -u)" -eq 0 ]; then
            export PS1='[$USER@$(hostname) \w]λ '
        elif [ -n "$PS1" ]; then
            export PS1='[$USER@$(hostname) \w]@ '
        fi
    }

    set_aliases() {
        alias ls='ls --color=auto'
        alias xbps-search='xbps-query -Rs'
        alias pointerkeys='setxkbmap -option keypad:pointerkeys'
        alias c='clear'
        alias sclear='clear && echo -e "\n \n"'
        alias ok='clear && oksh'
        alias myip='curl ipinfo.io/ip && printf "\n"'
        alias glbl_status='curl https://status.plaintext.sh/t'
        alias xbps-src='/portstree/xbps-src'
        alias zbps-install='sudo xbps-install'
        alias zbps-remove='sudo xbps-remove'
        alias djoke='curl -SsL https://icanhazdadjoke.com | cowsay'
    }

    load_profile() {
        if [ -r "$HOME/.profile" ]; then
            . "$HOME/.profile"
        fi
    }

    load_base16_shell() {
        BASE16_SHELL="$HOME/.config/base16-shell/"
        if [ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ]; then
            . "$BASE16_SHELL/profile_helper.sh"
            # base16_tomorrow
        fi
    }

    set_prompt
    set_aliases
    load_profile
    load_base16_shell
fi
