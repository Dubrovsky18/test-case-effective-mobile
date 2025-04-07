#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "Failed: Run script with root privileges"
    exit 1
fi

echo "Check dependency..."
for cmd in curl pgrep systemctl; do
    if ! command -v "$cmd" > /dev/null; then
        echo "'$cmd' not installed. Install this? (y/n)"
        read -r answer
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            echo "Installing $cmd..."
            sudo apt-get install -y "$cmd"
            if [ $? -ne 0 ]; then
                echo "Error in installing $cmd."
                exit 1
            fi
        else
            echo "Nesseccry intsall установить $cmd for continue."
            exit 1
        fi
    fi
done

SCRIPT_PATH="/usr/local/bin/monitor_test.sh"
REMOTE_SCRIPT_PATH="https://raw.githubusercontent.com/Dubrovsky18/test-case-effective-mobile/refs/heads/main/monitor-test.sh"
LOG_FILE="/var/log/monitoring.log"
SERVICE_FILE="/etc/systemd/system/monitor-test.service"
REMOTE_SERVICE_FILE="https://raw.githubusercontent.com/Dubrovsky18/test-case-effective-mobile/refs/heads/main/monitor-test.service"
TIMER_FILE="/etc/systemd/system/monitor-test.timer"
REMOTE_TIMER_FILE="https://raw.githubusercontent.com/Dubrovsky18/test-case-effective-mobile/refs/heads/main/monitor-test.timer"

sudo curl -o $SCRIPT_PATH $REMOTE_SCRIPT_PATH 
sudo chmod +x $SCRIPT_PATH

touch $LOG_FILE

sudo curl -o $SERVICE_FILE $REMOTE_SERVICE_FILE

sudo curl -o $TIMER_FILE $REMOTE_TIMER_FILE

systemctl enable monitor-test.service --now
systemctl enable monitor-test.timer --now