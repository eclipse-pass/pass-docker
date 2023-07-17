#!/bin/bash

echo "configuring sqs"
echo "==================="

# https://docs.aws.amazon.com/cli/latest/reference/sqs/create-queue.html
create_queue() {
  local QUEUE_NAME_TO_CREATE=$1
  awslocal sqs create-queue --queue-name ${QUEUE_NAME_TO_CREATE} --attributes VisibilityTimeout=30
}

create_queue "submission-event"
create_queue "submission"
create_queue "deposit"