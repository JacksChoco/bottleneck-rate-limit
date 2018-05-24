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

ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  service create --cluster ${PROJECT_NAME} \
  --deployment-max-percent 200 \
  --deployment-min-healthy-percent 50 \
  --target-group-arn ${TARGET_GROUP_ARN} \
  --health-check-grace-period 30 \
  --container-name ${PROJECT_NAME} \
  --container-port 3000 \
  --create-log-groups

  ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  service up \
  --cluster ${PROJECT_NAME}