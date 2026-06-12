import os
import boto3
import json
import logging
import urllib.request
from datetime import datetime, timezone

# Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

asg = boto3.client("autoscaling")
ec2 = boto3.client("ec2")
API_BASE_URL = "https://api.austwel.xyz"

ASG_NAME = os.environ.get("ASG_NAME")
ASG_HUMAN_NAME = os.environ.get("ASG_HUMAN_NAME")
BOT_TOKEN = os.environ.get("BOT_TOKEN")
CHANNEL_ID = os.environ.get("CHANNEL_ID")
MESSAGE_ID = os.environ.get("MESSAGE_ID")
HOST_NAME = os.environ.get("HOST_NAME")


def td_format(td_object):
    seconds = int(td_object.total_seconds())
    periods = [
        ('year',        60*60*24*365),
        ('month',       60*60*24*30),
        ('day',         60*60*24),
        ('hour',        60*60),
        ('minute',      60)
    ]

    strings = []
    for period_name, period_seconds in periods:
        if seconds > period_seconds:
            period_value, seconds = divmod(seconds, period_seconds)
            has_s = 's' if period_value > 1 else ''
            strings.append("%s %s%s" % (period_value, period_name, has_s))

    return ", ".join(strings)


def _json_response(status_code: int, body_obj) -> dict:
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body_obj)
    }


def lambda_handler(event, context):
    try:
        response = asg.describe_auto_scaling_groups(AutoScalingGroupNames=[ASG_NAME])
        group = response['AutoScalingGroups'][0]
        desired = group.get('DesiredCapacity')
        status = len(group.get('Instances', [])) == 1

        # Defaults
        instance_id = None
        instance_type = None
        state = None
        arch = None
        uptime = None

        if status:
            instance_id = group['Instances'][0]['InstanceId']

            ec2_response = ec2.describe_instances(InstanceIds=[instance_id])
            inst = ec2_response['Reservations'][0]['Instances'][0]
            state = inst['State']['Name']
            instance_type = inst['InstanceType']
            launch_time = inst['LaunchTime']
            arch = inst.get('Architecture')

            now = datetime.now(timezone.utc)
            uptime = td_format(now - launch_time)

        payload = {
            "embeds": [{
                "title": ASG_HUMAN_NAME,
                "url": "https://aws.austwel.xyz/",
                "description": "Server information",
                "timestamp": datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + 'Z',
                "fields": ([
                    {"name": "Host", "value": HOST_NAME or "-", "inline": False},
                ] + ([
                    {"name": "Instance Type", "value": instance_type, "inline": True},
                    {"name": "Instance ID", "value": instance_id, "inline": True},
                    {"name": "Architecture", "value": arch, "inline": True},
                    {"name": "State", "value": state, "inline": True},
                    {"name": "Uptime", "value": uptime, "inline": True},
                ] if status else [
                    {"name": "State", "value": "Stopped", "inline": False}
                ]))
            }]
        }

        url = f"https://discord.com/api/v10/channels/{CHANNEL_ID}/messages/{MESSAGE_ID}"
        headers = {
            "Authorization": f"Bot {BOT_TOKEN}",
            "Content-Type": "application/json",
            "User-Agent": "DiscordBot (Greg, 1.0.0)"
        }

        data = json.dumps(payload).encode("utf-8")
        req = urllib.request.Request(url, data=data, headers=headers, method="PATCH")

        with urllib.request.urlopen(req) as response:
            resp_text = response.read().decode('utf-8')
            resp_code = response.getcode()
            logger.info("Discord update response: %s", resp_code)
            return _json_response(resp_code, {"status": "patched", "response": resp_text})

    except Exception as e:
        logger.exception("Failed to update Discord message: %s", e)
        return _json_response(500, {"error": str(e)})
