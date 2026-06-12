import os
import boto3
import json
import logging
import base64

from nacl.signing import VerifyKey
from nacl.exceptions import BadSignatureError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

asg = boto3.client("autoscaling")
API_BASE_URL = "https://api.austwel.xyz"

ASG_NAME = os.environ.get("ASG_NAME")
ASG_HUMAN_NAME = os.environ.get("ASG_HUMAN_NAME")
BOT_TOKEN = os.environ.get("BOT_TOKEN")
CHANNEL_ID = os.environ.get("CHANNEL_ID")
MESSAGE_ID = os.environ.get("MESSAGE_ID")
DISCORD_PUBLIC_KEY = os.environ.get("DISCORD_PUBLIC_KEY")


def verify_signature(payload: bytes, signature, timestamp: str) -> bool:
    if not signature or not timestamp or not DISCORD_PUBLIC_KEY:
        logger.warning("Missing signature/timestamp/public key for verification")
        return False

    try:
        verify_key = VerifyKey(bytes.fromhex(DISCORD_PUBLIC_KEY))
        verify_key.verify(timestamp.encode() + payload, bytes.fromhex(signature))
        return True
    except BadSignatureError:
        logger.warning("Bad signature")
        return False
    except Exception as e:
        logger.exception("Unexpected error while verifying signature: %s", e)
        return False


def _json_response(status_code: int, body_obj) -> dict:
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body_obj)
    }


def lambda_handler(event, context):
    # Normalize headers to lower-case for reliable access
    headers = {k.lower(): v for k, v in (event.get("headers") or {}).items()}
    signature = headers.get("x-signature-ed25519")
    timestamp = headers.get("x-signature-timestamp")

    # Support API Gateway base64-encoded bodies
    is_b64 = event.get("isBase64Encoded")
    raw_body = event.get("body") or ""

    try:
        if is_b64:
            body_bytes = base64.b64decode(raw_body)
            logger.debug("Received base64-encoded body (%d bytes)", len(body_bytes))
        else:
            body_bytes = raw_body.encode("utf-8")
            logger.debug("Received text body (%d bytes)", len(body_bytes))
    except Exception as e:
        logger.exception("Failed to decode request body: %s", e)
        return _json_response(400, {"error": "Invalid request body encoding"})

    # Log headers for diagnosis (avoid logging secrets)
    logger.info("Request headers: %s", list(headers.keys()))
    logger.debug("Body preview: %s", (body_bytes[:200].decode('utf-8', 'replace')))

    if not verify_signature(body_bytes, signature, timestamp):
        return _json_response(401, {"error": "Bad Signature"})

    try:
        body = json.loads(body_bytes.decode("utf-8"))
    except Exception as e:
        logger.exception("Failed to parse request body: %s", e)
        return _json_response(400, {"error": "Invalid JSON body"})

    itype = body.get("type")

    # Discord PING
    if itype == 1:
        return _json_response(200, {"type": 1})

    # Other non-interaction types: no content
    if itype is None:
        return {"statusCode": 204, "headers": {}, "body": ""}

    # Component interaction (button press)
    if itype == 3:
        try:
            interaction_data = body.get("data", {})
            custom_id = interaction_data.get("custom_id")
            desired_capacity = 1 if custom_id == "start" else 0

            logger.info("Scaling ASG %s to %s (button: %s)", ASG_NAME, desired_capacity, custom_id)
            autoscaling = boto3.client("autoscaling")
            autoscaling.set_desired_capacity(
                AutoScalingGroupName=ASG_NAME,
                DesiredCapacity=desired_capacity,
                HonorCooldown=True,
            )

            # Respond with a deferred update acknowledgement
            return _json_response(200, {"type": 6})

        except Exception as e:
            logger.exception("Error while handling interaction: %s", e)
            return _json_response(500, {"error": "Failed to scale ASG"})

    # Unknown interaction type
    return _json_response(400, {"error": "Unsupported interaction type"})