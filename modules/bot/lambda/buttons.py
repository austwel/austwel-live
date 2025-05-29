import os
import boto3
import json
import urllib.request
import base64
import os
import time
import threading
from datetime import datetime
import requests

from nacl.signing import VerifyKey
from nacl.exceptions import BadSignatureError

asg = boto3.client("autoscaling")
API_BASE_URL = "https://api.austwel.xyz"

ASG_NAME = os.environ["ASG_NAME"]
ASG_HUMAN_NAME = os.environ["ASG_HUMAN_NAME"]
BOT_TOKEN = os.environ["BOT_TOKEN"]
CHANNEL_ID = os.environ["CHANNEL_ID"]
MESSAGE_ID = os.environ["MESSAGE_ID"]
DISCORD_PUBLIC_KEY = os.environ["DISCORD_PUBLIC_KEY"]

def verify_signature(payload: bytes, signature, timestamp: str):
  verify_key = VerifyKey(bytes.fromhex(DISCORD_PUBLIC_KEY))


  try:
    verify_key.verify(timestamp.encode() + payload, bytes.fromhex(signature))
    return True
  except (BadSignatureError) as e:
    return False

def lambda_handler(event, context):
  body = json.loads(event['body'])

  signature = event['headers']['x-signature-ed25519']
  timestamp = event['headers']['x-signature-timestamp']
  
  if not verify_signature(bytes(event['body'],'utf-8'), signature, timestamp):
    return {
      "statusCode": 401,
      "body": "Bad Signature"
    }
    
  if body['type'] == 0:
    return {
      "statusCode": 204
    }
  
  if body['type'] == 1:
    return json.dumps({"type": 1})
  
  if body['type'] == 3:
    token = body["token"]
    application_id = body["application_id"]
    interaction_data = body["data"]
    desired_capacity = 1 if body['data']['custom_id'] == "start" else 0
    status = "Running" if desired_capacity > 0 else "Stopped"
    
    print(f'Scaling to {desired_capacity}')
    response = requests.post(f"{API_BASE_URL}/scale-{ASG_NAME}", json={"desired_capacity": desired_capacity})

    print('Closing the interaction')
    return json.dumps({"type":6})