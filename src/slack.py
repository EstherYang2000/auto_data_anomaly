# from slack_sdk import WebClient

# client = WebClient(token="xoxb-8171168589846-8200667728080-QrBMxmU3EpPFqfYmjGqXuvZi")
# response = client.chat_postMessage(channel="C085WHPFL9W", text="Hello, world!")
# print(response)

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

client = WebClient(token="xoxb-8171168589846-8200667728080-rDpMAxUTvOZpXtYR5iz8LH07")

try:
    response = client.chat_postMessage(channel="C085WHPFL9W", text="Hello, world!")
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
