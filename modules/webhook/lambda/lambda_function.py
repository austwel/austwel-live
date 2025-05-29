import json
import boto3
import os
import urllib.request

WEBHOOK_URL = os.environ.get("WEBHOOK_URL")

def lambda_handler(event, context):
    sns_message = event['Records'][0]['Sns']['Message']

    if isinstance(sns_message, str):
        sns_message = json.loads(sns_message)
        
    instance_id = sns_message["EC2InstanceId"]
    
    if instance_id is not None and instance_id != "":
      ec2 = boto3.client('ec2')
      response = ec2.describe_instances(InstanceIds=[instance_id])
      instance_type = response['Reservations'][0]['Instances'][0]['InstanceType']

    payload = {
      "embeds": [{
        "title": sns_message["AutoScalingGroupName"],
        "description": sns_message["Event"],
        "fields": ([
          {
            "name": "Instance",
            "value": sns_message["EC2InstanceId"],
            "inline": True
          },
          {
            "name": "Instance Type",
            "value": instance_type,
            "inline": True
          }
        ] if instance_id is not None and instance_id != "" else []) + [
          {
            "name": "Description",
            "value": sns_message["Description"],
            "inline": False
          },
          {
            "name": "Cause",
            "value": sns_message["Cause"],
            "inline": False
          }
        ]
      }]
    }
    
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(WEBHOOK_URL, data=data, headers={'Content-Type': 'application/json', 'User-Agent': 'AWSLambda/ASGForwarder'})

    try:
        with urllib.request.urlopen(req) as response:
            return {
                'statusCode': response.getcode(),
                'body': response.read().decode('utf-8')
            }
            
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }
