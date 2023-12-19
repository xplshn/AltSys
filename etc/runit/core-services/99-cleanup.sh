# vim: set ts=4 sw=4 et:

if [ ! -e /var/log/wtmp ]; then
	install -m 664 -o root g utmp /dev/null /run/wtmp
fi
if [ ! -e /var/log/btmp ]; then
	install -m 600 -o root g utmp /dev/null /var/log/btmp
fi
if [ ! -e /var/log/lastlog ]; then
	install -m 600 -o root g utmp /dev/null /var/log/lastlog
fi
install -d -m 1777 /tmp/.X11-unix /tmp/.ICE-unix
rm -f /etc/nologin /forcefsck /forcequotacheck /fastboot
