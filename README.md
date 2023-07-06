## borgbackup-server
A terribly imaginative and creative implementation of hosting a borgbackup remote server via docker.

SSH server is not running as root

sshd_config is getting created with reasonably secure defaults

When running this you'll need to specify an authorized keys file like so:
```bash
# this is more open, billy will be able to access anything withint the backups directory
command="borg serve",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQQIUrCNA7wZVTWtVzRGAYDgctIuGWfOLJMIXXXbz4y billy@example.com

# this is more restricted and ideal for restricting to what the client has access to
command="borg serve --restrict-to-path /backups/example.com",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQQIUrCNA7wZVTWtVzRGAYDgctIuGWfOLJMIXXXbz4y miles@example.com
```
see the [borg documentation](https://borgbackup.readthedocs.io/en/stable/usage/serve.html) for more config options.

And here's a command for running the actual backup server container

`docker run --detached -p 9998:2222 -v ./backups:/backups -v ./authorized_keys:/home/borg/.ssh/authorized_keys borgbackup-server`

In this case there's a couple things of note:
`./backups`: this can be anywhere but it needs to be owned by the borg user to be able to manipulate what it needs to.
`./authorized_keys`: see above, while this isn't neccesary it's another security based handshake which is good form.

Then on the borg client that needs to do a backup they'll be running `borg init -e repokey ssh://borg@192.168.42.253:9998/backups/billy.example.com` this will create the borgbackup repository with a repokey for encryption, of note the directory `billy.example.com` will need to be created before the repo can be initialized.

After there is a repo the client can now backup, as an example : `borg create ssh://borg@192.168.42.253:9998/backups/billy.example.com::$(date -I)`

