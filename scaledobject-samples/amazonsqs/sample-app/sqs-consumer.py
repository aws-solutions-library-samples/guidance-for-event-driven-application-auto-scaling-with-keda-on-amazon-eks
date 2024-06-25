import logging
import os
import time

import boto3

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
AWS_REGION = os.getenv("AWS_REGION")
RELIABLE_QUEUE = os.getenv("RELIABLE_QUEUE_NAME")
MAX_MESSAGES_PER_BATCH = int(os.getenv("MAX_MSGS_PER_BATCH", 5)) 
MESSAGE_POLL_BACKOFF = int(os.getenv("MSG_POLL_BACKOFF", 2))
MESSAGE_PROCESS_DELAY = int(os.getenv("MSG_PROCESS_DELAY", 10))  
TOTAL_MESSAGES_TO_PROCESS = int(os.getenv("TOT_MSGS_TO_PROCESS", 10))

logger = logging.getLogger(__name__)
logger.setLevel(LOG_LEVEL)

sqs = boto3.client("sqs", region_name=AWS_REGION)

while True:
    resp = sqs.receive_message(
        QueueUrl=RELIABLE_QUEUE, MaxNumberOfMessages=MAX_MESSAGES_PER_BATCH
    )

    if "Messages" not in resp:
        logger.warning("No messages in queue %s", RELIABLE_QUEUE)
        time.sleep(MESSAGE_POLL_BACKOFF)
        continue

    for msg in resp["Messages"]:
        body = msg["Body"]
        receipt = msg["ReceiptHandle"]

        # Process message body
        logger.info("Processed %s", body) 
        time.sleep(MESSAGE_PROCESS_DELAY)

        # Delete if processing succeeded
        sqs.delete_message(QueueUrl=RELIABLE_QUEUE, ReceiptHandle=receipt)
        logger.info("Deleted %s", receipt)

    if TOTAL_MESSAGES_TO_PROCESS and len(resp["Messages"]) >= TOTAL_MESSAGES_TO_PROCESS:
        logger.info("Processed %d messages, exiting", TOTAL_MESSAGES_TO_PROCESS)
        break
