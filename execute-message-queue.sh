#!/bin/bash

# Define the queue URL
QUEUE_URL="https://sqs.us-east-1.amazonaws.com/961341523711/message-queue"

# Read message from SQS
MESSAGE_JSON=$(aws sqs receive-message --queue-url "$QUEUE_URL" --max-number-of-messages 1 --wait-time-seconds 15)

# Check if a message was received
if [ -z "$MESSAGE_JSON" ]; then
    echo "NO MESSAGES RECEIVED."
    exit 0
fi

# Extract message body and receipt handle
MESSAGE_BODY=$(echo "$MESSAGE_JSON" | jq -r '.Messages[0].Body')
RECEIPT_HANDLE=$(echo "$MESSAGE_JSON" | jq -r '.Messages[0].ReceiptHandle')

# Print executed message
echo "MESSAGE EXECUTED: $MESSAGE_BODY"
 
# Delete message from SQS
aws sqs delete-message --queue-url "$QUEUE_URL" --receipt-handle "$RECEIPT_HANDLE"

echo "MESSAGE DELETED FROM QUEUE."