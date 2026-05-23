#!/bin/sh

while true; do
    # Send HTTP request and check for 200 OK
    if printf "GET / HTTP/1.1\r\nHost: insideweb\r\nConnection: close\r\n\r\n" | nc -w 2 insideweb 80 | grep -q "200 OK"; then
        echo "System up."
    else
        echo "System down! Sending alert..."
        # Ensure the mail service expects raw text; otherwise, use SMTP or HTTP
        printf "To: admin@work\r\nSubject: Service Down\r\n\r\nThe service is down!" | nc -w 5 $INSIDEMAILER_PORT_33333_TCP_ADDR $INSIDEMAILER_PORT_33333_TCP_PORT
        break
    fi
    sleep 1
done