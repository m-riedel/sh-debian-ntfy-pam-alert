# Setup script for ntfy alerts on ssh login

This script configures debian to sent a notification to a ntfy server on ssh login. This is inspired by https://docs.ntfy.sh/examples/#ssh-login-alerts

## Quickstart

> Note: The script will do the following: create a file /usr/bin/ntfy-pam-alert.sh with 755 permissions, that excecutes a curl to the specified ntfy server. Append to /etc/pam.d/sshd to execute /usr/bin/ntfy-pam-alert.sh if not already exists.

> When running the script for a second time all configuration will be overridden. 

Run the following command to execute the script:

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/m-riedel/sh-debian-ntfy-pam-alert/main/setup.sh)"
```

If you want to provide options run this command and replace all values like `<foo>`

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/m-riedel/sh-debian-ntfy-pam-alert/main/setup.sh)" setup -t <TOPIC> -u <NTFY_SERVER_URL> -a <ACCESS_TOKEN>
```

If you don't like directly executing the script clone the repo and execute afterwards.

```shell
git clone https://github.com/m-riedel/sh-debian-ntfy-pam-alert.git
cd sh-debian-ntfy-pam-alert
chmod 755 setup.sh
./setup.sh
```

You can also supply the options like above:

```shell
git clone https://github.com/m-riedel/sh-debian-ntfy-pam-alert.git
cd sh-debian-ntfy-pam-alert
chmod 755 setup.sh
./setup.sh -t <TOPIC> -u <NTFY_SERVER_URL> -a <ACCESS_TOKEN>
```

## Available Options
| Option | Description                                                      |
|--------|------------------------------------------------------------------|
|    a   |  Optional: Sets the authentication token. Only Bearer available. |
|    h   |  Print this Help.                                                |
|    n   |  Optional: Sets the node name. Default: hostname is used         |
|    t   |  Optional: Sets the topic name. Default: A prompt is shown       |
|    u   |  Optional: Sets the ntfy server url. Default: ntfy.sh            |
