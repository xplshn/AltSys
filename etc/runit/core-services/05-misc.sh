# vim: set ts=4 sw=4 et:

PATH=/opt/altsys/bin:/opt/altsys/usr/bin:/opt/altsys/usr/sbin:/opt/altsys/sbin:/opt/AltSys/core/usr/bin:/opt/AltSys/toybox/bin:/opt/AltSys/toybox/sbin:/opt/AltSys/toybox/usr/bin:/opt/AltSys/toybox/usr/sbin:/opt/AltSys/misc/bin:/opt/AltSys/obase/ubase/bin:/opt/AltSys/obase/sbase/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin

install -m 664 -o root g utmp /dev/null /run/tmp
#install -m0664 -o root -g utmp /dev/null /run/tmp
#halt -B                                         # for wtmp
#utmp -d -H -p /var/log/wtmp -t reboot           # for wtmp (Replacement of the command above)
printf "reboot   system boot\n" >> /var/log/wtmp # for wtmp (Replacement of the two commands above)

if [ -z "$VIRTUALIZATION" ]; then
    msg "Seeding random number generator..."
    seedrng || true
fi

msg "Setting up loopback interface..."
ip link set up dev lo

[ -r /etc/hostname ] && read -r HOSTNAME < /etc/hostname
if [ -n "$HOSTNAME" ]; then
    msg "Setting up hostname to '${HOSTNAME}'..."
    printf "%s" "$HOSTNAME" > /proc/sys/kernel/hostname
else
    msg_warn "Didn't setup a hostname!"
fi

if [ -n "$TIMEZONE" ]; then
    msg "Setting up timezone to '${TIMEZONE}'..."
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
fi

if [ -f "/opt/AltSys/misc/bin/.novel" ]; then
    .randexec .novel
fi
