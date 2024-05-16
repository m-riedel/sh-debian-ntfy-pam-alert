#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
    # Display Help
    echo "This script sets up optional alerts to a ntfy server on ssh login"
    echo
    echo "Syntax: setup.sh [-a|h|n|t|u]"
    echo "options:"
    echo "a     Optional: Sets the authentication token. Only Bearer available."
    echo "h     Print this Help."
    echo "n     Optional: Sets the node name. Default: hostname is used"
    echo "t     Optional: Sets the topic name. Default: A prompt is shown"
    echo "u     Optional: Sets the ntfy server url. Default: ntfy.sh"
    echo
}

############################################################
# Main program                                             #
############################################################

# Get the options

while getopts "a::hn:t:u:" option; do
    case $option in
        a)
            AUTH_TOKEN=$OPTARG
            ;;
        h) 
            Help
            exit;;
        n)
            NODE=$OPTARG
            ;;
        t)
            TOPIC=$OPTARG
            ;;
        u)
            URL=$OPTARG
            ;;
        \?) # Invalid option
            echo "Error: Invalid option"
            Help
            exit;;
    esac
done

if [ -z "$TOPIC" ]; then
    read -p "Topic: " TOPIC
fi

if [ -z "$NODE" ]; then
    NODE=$(hostname)
fi

if [ -z "$URL" ]; then
    URL="https://ntfy.sh"
fi

if [ ! -z "$AUTH_TOKEN" ]; then
    AUTH_HEADER="-H \"Authorization: Bearer $AUTH_TOKEN\""
fi

TOPIC_URL="$URL/$TOPIC"

if [ ! -f /usr/bin/ntfy-pam-alert.sh ]; then
    touch /usr/bin/ntfy-pam-alert.sh
fi

chmod 755 /usr/bin/ntfy-pam-alert.sh

tee /usr/bin/ntfy-pam-alert.sh << EOF
#!/bin/bash

NODE=$NODE
URL=$TOPIC_URL

if [ "\${PAM_TYPE}" = "open_session" ]; then
  if [ "\${PAM_USER}" = "root" ]; then
    PRIORITY=urgent
  else
    PRIORITY=high
  fi

  curl $AUTH_HEADER \\
    -H "Priority: \${PRIORITY}" \\
    -H tags:warning \\
    -H "Title: \${NODE} - SSH Login" \\
    -d "SSH login on node \${NODE}: \${PAM_USER} from \${PAM_RHOST}" \\
    \$URL
fi
EOF

grep -qxF 'session optional pam_exec.so /usr/bin/ntfy-pam-alert.sh' /etc/pam.d/sshd || echo 'session optional pam_exec.so /usr/bin/ntfy-pam-alert.sh' >> /etc/pam.d/sshd

systemctl restart sshd
