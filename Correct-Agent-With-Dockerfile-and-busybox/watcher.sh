#!/bin/sh

WEB_HOST="web"  # Docker DNS name
MAIL_HOST="mailer" # Docker DNS name
MAIL_PORT=33333

while true; do
    # Check Web Service
    # Try to get just the headers to check status code
    RESPONSE=$(printf "GET / HTTP/1.0\r\nHost: $WEB_HOST\r\n\r\n" | nc -w 2 "$WEB_HOST" 80 2>/dev/null)
    
    # Check if 200 OK is in the first line (Status Line)
    if echo "$RESPONSE" | head -n 1 | grep -q "200"; then
        echo "$(date): System UP."
    else
        echo "$(date): System DOWN! Sending alert..."
        
        # Prepare Alert Message
        ALERT_MSG="To: admin@work\r\nSubject: Service Down Alert\r\n\r\nThe service $WEB_HOST is down at $(date)!"
        
        # Send Alert via TCP to Mailer
        # Note: We pipe directly to nc. 
        printf "$ALERT_MSG" | nc -w 2 "$MAIL_HOST" "$MAIL_PORT"
        
        if [ $? -eq 0 ]; then
            echo "Alert sent successfully."
        else
            echo "Failed to send alert."
        fi
    fi
    
    sleep 10
done