Run transmission-daemon inside a container, routing its network traffic through an OpenVPN tunnel, without impacting the host system's networking configuration.

## Building The Container

`$ sudo podman build -t trans-vpn -f  <path>/Dockerfile`

## Configuring The Container

The container has the following external connections:
- Volumes:
  - /transmission - the persistent store for the transmission-daemon.  The `settings.json` file needs to be located here and this is the default directory for torrent downloads.  It also contains all of the data that the daemon uses to maintain state, i.e., to remember what it was doing the last time it ran.
  - /etc/openvpn/client - the `openvpn.conf` file needs to be located here.  This file would usually be provided by whomever it is provides your VPN services.
  - /var/logs - The transmission and openvpn logs are written to this directory.  You can map this volume to a directory outside the container if you want to be able to monitor the logs.  (This is optional.)
- Ports:
  - 9091/tcp - This is the transmission RPC port that is used for remote access to manage the transmission daemon using tools like transmission-remote or trans-gui.  For simplicity this should probably be mapped to port 9091 on the host machine unless there's a good reason not to do so.
  <br />By default, the transmission-daemon's RPC port is only available on the system which is hosting the podman container.  Port forwarding must be configured to make this port available to other systems.  See the `run-trans-vpn` script for an example of the commands that can be used to create that configuration.
- The `settings.json` file:
<br />This must be present in the directory that `/transmission` has been mapped to.  If it is not, the transmission daemon will create it the first time the container runs.  This file contains the settings which enable access to the transmission-daemon running inside the container.  A sample file is provided as part of this project which is set to permit RPC access to the daemon using the userid "admin" with the password "transmission".  You may set you own more secure password in the file if you wish.  To do this use this procedure:
  1) Shutdown the trans-vpn podman container
  2) Edit the settings.json file in the `/transmission` directory
  3) Set the `rpc-password =` value to the plain-text password you want to use
  4) Restart the container.  The daemon will detect that the password is in plaintext format and will rewrite the password as a hash in the `settings.json` file as it starts up.
<br /><br />Always use a strong password.  Hackers have unlimited access to attempt to guess your transmission RPC password and break in.

## Running The Container

The `run-trans-vpn` script can be used to start the container and set up the necessary port forwarding for port 9091.  See the script for examples of the `podman` and `firewall-cmd` commands used to do these things.

After starting the container, use tools like `transmission-remote` or `transgui` to administer the daemon:

`transmission-remote -n admin:password -si`

$$ License

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
