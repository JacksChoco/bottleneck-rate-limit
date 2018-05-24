#!/usr/bin/env bash
source ./bin/env.sh

ecs-cli configure --cluster ${PROJECT_NAME} --region ${REGION} \
  --default-launch-type EC2 --config-name ${PROJECT_NAME}

ecs-cli configure profile --access-key ${AWS_ACCESS_KEY_ID} \
  --secret-key ${AWS_SECRET_ACCESS_KEY} --profile-name  ${PROJECT_NAME}


ecs-cli up --keypair ${KEY_PAIR} \
  --security-group ${SECURITY_GROUP} --cluster ${PROJECT_NAME} \
  --vpc ${VPC} --subnets ${SUBNET} \
  --capability-iam --size 2 --instance-type ${INSTANCE_TYPE}