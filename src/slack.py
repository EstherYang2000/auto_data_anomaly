from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
import os

client = WebClient(token=os.environ["SLACK_API_TOKEN"])

try:
    response = client.chat_postMessage(channel=os.environ("CHANNEL"), text="Hello, world!")
    print("Message sent successfully:", response)
except SlackApiError as e:
    print(f"Error sending message: {e.response['error']}")

# response = client.conversations_list()
# for channel in response["channels"]:
#     if channel["name"] == "dbt":
#         print(channel["id"])


# import ssl
# import certifi

# ssl_context = ssl.create_default_context(cafile=certifi.where())
