#!/bin/bash

# Load environment variables from .env file
if [ -f ./.env ]; then
  export $(cat ./.env | xargs)
fi

# Retrieve the ngrok URL
NGROK_TUNNELS=$(curl --silent http://127.0.0.1:4040/api/tunnels)
NGROK_URL=$(echo $NGROK_TUNNELS | grep -o '"public_url":"[^"]*' | grep -o 'http[^"]*')

# Check if the URL was retrieved successfully
if [[ $NGROK_URL == http* ]]; then
  # Update the Telegram webhook
  RESPONSE=$(curl --location --request POST "https://api.telegram.org/bot$BOT_TOKEN/setWebhook" \
    --header 'Content-Type: application/json' \
    --data '{"url": "'"$NGROK_URL"'"}')

  # Output the response
  echo "Webhook updated with new ngrok URL: $NGROK_URL"
  echo "Response from Telegram API: $RESPONSE"
else
  echo "Failed to retrieve ngrok URL."
fi


curl --location 'https://api.telegram.org/bot{{BOT_TOKEN}}/setWebhook' \
--header 'Content-Type: application/json' \
--data '{
"url": "{{NGROK_URL}}"
}'







