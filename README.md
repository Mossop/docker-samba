# Samba Server

This is a docker container that runs the latest stable build of Samba.
Primarily this gives Time Machine support without any special patches.

The goal is for this to be lightweight but the focus for now is getting
something working so there is probably plenty of scope for cleanup.

## Installing

Not much to install, it's just a docker container. You'll need to create a
configuration directory with a `smb.conf` file in it. You should probably
uninstall avahi-daemon and samba from your host.

You should have a unix group named "nobody" on the host.

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
Time Machine. The configuration is a little tricky though. You might start
here: https://www.reddit.com/r/homelab/comments/83vkaz/howto_make_time_machine_backups_on_a_samba/

You may find you need to use `tmutil setdestination` to configure backups
rather than using the UI.
