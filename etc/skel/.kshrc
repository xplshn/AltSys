# .okshrc ######################
HISTFILE="$HOME/.sh_history"   #
LOCATION=""                    #
################################

set_prompt() {
    PS1="[$USER@$(hostname) \w]"
    [ "$(id -u)" -eq 0 ] && PS1="${PS1}λ " || PS1="${PS1}@ "
    export PS1
}

base16_loader() {
	# Base16 Shell
	BASE16_SHELL="$HOME/.config/base16-shell/"
	[ -n "$PS1" ] &&
		[ -f "$BASE16_SHELL/profile_helper.sh" ] &&
		. "$BASE16_SHELL/profile_helper.sh"
}

alias_loader() {
	alias ls='ls --color=auto'
	alias c='clear'
#	alias myip='curl ipinfo.io/ip && printf "\n"'
#	alias glbl_status='curl https://status.plaintext.sh/t'
	alias fortune='printf "\033[38;2;66;217;239m$(fortune) \n \033[0m"'
#	alias fortune-online='curl -SsL https://icanhazdadjoke.com | cowsay'
#	alias wttr='wttr $LOCATION' # Enable once you modify $LOCATION
}

load_profile() {
if [ -r "$HOME/.profile" ]; then
	. "$HOME/.profile"
fi
}

#show_weatherInfo() {
#	if ping -q -c 1 -W 1 wttr.in >/dev/null; then
#		wttr "$LOCATION"
#	fi
#} # Enable once you modify $LOCATION

set_prompt
alias_loader
base16_loader
show_weatherInfo
