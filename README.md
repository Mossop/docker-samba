# Samba Server

This is a docker container that runs the latest stable build of Samba.
Primarily this gives Time Machine support without any special patches.

The goal is for this to be lightweight but the focus for now is getting
something working so there is probably plenty of scope for cleanup.

## Installing

Not much to install, it's just a docker container. You'll need to create a
configuration directory with a `smb.conf` file in it. You should probably
uninstall avahi-daemon and samba from your host.

## Running

A few things need to be set to make the server work. We use host networking
so Samba knows what subnet it is running on and exposes the appropriate
ports. We also expose passwd and group to the container so it can map users
correctly. Then it is just a matter of mapping your configuration directory
plus any directories you want to share.

    docker run --network host \
               -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro \
               -v <configdir>:/etc/samba \
               -v /mnt:/mnt -v /home:/home

## Authentication

Once up and running you will need to run smbpasswd to add user accounts.

    docker exec -it <container> smbpasswd -a <username>

If your smb.conf doesn't point the password database to a mounted volume
these accounts will be lost if the container is re-created.

## Time Machine

The Samba in this container supports being configured as a destination for
Time Machine.

Register a backup destination in smb.conf with something like this:

    [Time Machine]
    	path = /mnt/backup/TimeMachine
    	writeable = yes
    	browseable = no
    
    	vfs objects = catia fruit streams_xattr
    
    	fruit:aapl = yes
    	fruit:time machine = yes

You should find your destination appear automatically in the Time Machine
preferences.

## Troubleshooting

If none of the services seem to start in the container make sure your host
(or whatever file you mount for `/etc/group` includes a group named
`nobody`.

If `avahi-daemon` is already running on the host then `avahi-daemon` will be
unable to start in the container and auto-discovery of shares and Time
Machine destinations will fail for other computers. You can still browse the
server directly in this case and for Time Machine use `tmutil
setdestination` to configure a backup destination.
