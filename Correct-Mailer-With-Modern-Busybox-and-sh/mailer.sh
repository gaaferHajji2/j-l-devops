#!/bin/sh

PORT=33333

echo "CH2 Example Mailer has started on port $PORT..."

while true; do
    echo "Waiting for incoming message..."
    
    # Listen for one connection. 
    # In Busybox/Alpine, nc -l exits after the connection closes.
    # We capture the output into a variable.
    MESSAGE=$(nc -l -p $PORT 2>/dev/null)
    
    if [ -n "$MESSAGE" ]; then
        echo "----------------------------------------"
        echo "Received Message:"
        echo "$MESSAGE"
        echo "----------------------------------------"
        # Here you would ideally parse the raw text and send a real email
        # or log it to a file.
    else
        echo "Empty message received or connection error."
    fi
    
    sleep 1
done