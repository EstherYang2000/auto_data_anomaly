from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
import os

client = WebClient(token=os.environ["SLACK_API_TOKEN"])

# response = client.conversations_list()
# for channel in response["channels"]:
#     if channel["name"] == "dbt":
#         print(channel["id"])


# import ssl
# import certifi

# ssl_context = ssl.create_default_context(cafile=certifi.where())
