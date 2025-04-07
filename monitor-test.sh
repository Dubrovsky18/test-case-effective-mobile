#!/bin/bash

LOG_FILE="/var/log/monitoring.log"

PID_FILE="/tmp/test_process.pid"

URL="https://test.com/monitoring/test/api"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

if pgrep -f "test" > /dev/null; then
    CURRENT_PID=$(pgrep -f "test" | head -n 1)

    if [ -f "$PID_FILE" ]; then
        PREVIOUS_PID=$(cat "$PID_FILE")
    else
        PREVIOUS_PID=""
    fi

    if [ "$CURRENT_PID" != "$PREVIOUS_PID" ] && [ -n "$PREVIOUS_PID" ]; then
        log_message "Process 'test' restarted. Previous PID: $PREVIOUS_PID, New PID: $CURRENT_PID"
    fi

    echo "$CURRENT_PID" > "$PID_FILE"

    if ! curl -s --fail "$URL" > /dev/null; then
        log_message "Monitoring server $URL is unavailable"
    fi
fi