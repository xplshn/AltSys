# vim: set ts=4 sw=4 et:

if [ -x /sbin/sysctl ] || [ -x /bin/sysctl ]; then
    msg "Loading sysctl(8) settings..."
    mkdir -p /run/vsysctl.d
    for i in /run/sysctl.d/*.conf \
        /etc/sysctl.d/*.conf \
        /usr/local/lib/sysctl.d/*.conf \
        /usr/lib/sysctl.d/*.conf; do

        if [ -e "$i" ] && [ ! -e "/run/vsysctl.d/$(basename "$i")" ]; then
            ln -s "$i" "/run/vsysctl.d/$(basename "$i")"
        fi
    done
    for i in /run/vsysctl.d/*.conf; do
        sysctl -p "$i"
    done
    rm -rf -- /run/vsysctl.d
    sysctl -p /etc/sysctl.conf
fi