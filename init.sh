#! /bin/sh

/usr/sbin/avahi-daemon -D
/usr/sbin/nmbd -D
/usr/sbin/winbindd -D
/usr/sbin/smbd -D

# Block container exit
tail -f /dev/null
