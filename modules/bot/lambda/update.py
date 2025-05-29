import os
import boto3
import json
import urllib.request
from datetime import datetime, timezone

asg = boto3.client("autoscaling")
ec2 = boto3.client("ec2")
API_BASE_URL = "https://api.austwel.xyz"

ASG_NAME = os.environ["ASG_NAME"]
ASG_HUMAN_NAME = os.environ["ASG_HUMAN_NAME"]
BOT_TOKEN = os.environ["BOT_TOKEN"]
CHANNEL_ID = os.environ["CHANNEL_ID"]
MESSAGE_ID = os.environ["MESSAGE_ID"]
HOST_NAME = os.environ["HOST_NAME"]

def td_format(td_object):
    seconds = int(td_object.total_seconds())
    periods = [
        ('year',        60*60*24*365),
        ('month',       60*60*24*30),
        ('day',         60*60*24),
        ('hour',        60*60),
        ('minute',      60)
    ]

    strings=[]
    for period_name, period_seconds in periods:
        if seconds > period_seconds:
            period_value , seconds = divmod(seconds, period_seconds)
            has_s = 's' if period_value > 1 else ''
            strings.append("%s %s%s" % (period_value, period_name, has_s))

    return ", ".join(strings)

def lambda_handler(event, context):
  response = asg.describe_auto_scaling_groups(
    AutoScalingGroupNames=[ASG_NAME]
  )
  group = response['AutoScalingGroups'][0]
  desired = group['DesiredCapacity']
  status = len(group['Instances']) == 1
  
  uptime = None
  if status:
    instance_id = group['Instances'][0]['InstanceId']
    
    ec2_response = ec2.describe_instances(InstanceIds=[instance_id])
    state = ec2_response['Reservations'][0]['Instances'][0]['State']['Name']
    instance_type = ec2_response['Reservations'][0]['Instances'][0]['InstanceType']
    launch_time = ec2_response['Reservations'][0]['Instances'][0]['LaunchTime']
    arch = ec2_response['Reservations'][0]['Instances'][0]['Architecture']
    
    now = datetime.now(timezone.utc)
    uptime = td_format(now - launch_time)

  payload = {
    "embeds": [{
      "title": ASG_HUMAN_NAME,
      "url": "https://aws.austwel.xyz/",
      "description": "Server information",
      "timestamp": datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + 'Z',
      "fields": ([
        {
          "name": "Host",
          "value": HOST_NAME,
          "inline": False
        },
        {
          "name": "Instance Type",
          "value": instance_type,
          "inline": True
        },
        {
          "name": "Instance ID",
          "value": instance_id,
          "inline": True
        },
        {
          "name": "Architecture",
          "value": arch,
          "inline": True
        },
        {
          "name": "State",
          "value": state,
          "inline": True
        },
        {
          "name": "Uptime",
          "value": uptime,
          "inline": True
        }
      ] if status else [
        {
          "name": "State",
          "value": "Stopped",
          "inline": False
        }
      ])
    }]
  }
  
  try:
    url = f"https://discord.com/api/v10/channels/{CHANNEL_ID}/messages/{MESSAGE_ID}"
    headers = {
      "Authorization": f"Bot {BOT_TOKEN}",
      "Content-Type": "application/json",
      "User-Agent": "DiscordBot (Greg, 1.0.0)"
    }

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers=headers, method="PATCH")
    
    with urllib.request.urlopen(req) as response:
      return {
        "statusCode": response.getcode(),
        "body": response.read().decode('utf-8')
      }

  except Exception as e:
    return {
      "statusCode": 500,
      "body": str(e)
    }
