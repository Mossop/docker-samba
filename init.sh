#! /bin/sh

net groupmap add sid=S-1-5-32-546 unixgroup=nobody type=builtin
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start

/usr/sbin/nmbd -D
/usr/sbin/winbindd -D
/usr/sbin/smbd -D

# Block container exit
tail -f /dev/null
