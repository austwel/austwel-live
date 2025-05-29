import boto3
import json
import os

client = boto3.client('autoscaling')
asg_name = os.environ['ASG_NAME']

def lambda_handler(event, context):
    try:
        # Read desired capacity from request body
        body = json.loads(event.get('body', '{}'))
        desired_capacity = body.get('desired_capacity')

        if desired_capacity not in [0, 1]:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "desired_capacity must be 0 or 1"})
            }

        # Set desired capacity
        client.set_desired_capacity(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=int(desired_capacity),
            HonorCooldown=False
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": f"ASG {asg_name} set to {desired_capacity}"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }