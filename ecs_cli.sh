#!/usr/bin/env bash

ecs-cli configure --cluster ${PROJECT_NAME} --region ${REGION} \
  --default-launch-type EC2 --config-name ${PROJECT_NAME}

ecs-cli configure profile --access-key ${AWS_ACCESS_KEY_ID} \
  --secret-key ${AWS_SECRET_ACCESS_KEY} --profile-name  ${PROJECT_NAME}


ecs-cli up --keypair ${KEY_PAIR} \
  --security-group ${SECURITY_GROUP} --cluster ${PROJECT_NAME} \
  --vpc ${VPC} --subnets ${SUBNET} \
  --capability-iam --size 1 --instance-type ${INSTANCE_TYPE}
# security group은 이름이 아닌 id로 넣어야한다! 이름을 넣으면 클러스터는 생기는데 인스턴스가 안생김...


# test compose container up
ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  up --create-log-groups --cluster ${PROJECT_NAME}

# test compose scale up
ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  scale 2 --cluster ${PROJECT_NAME}

# shutdown compose container
ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  down --cluster ${PROJECT_NAME}

# 서비스 생성
ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  service create --cluster ${PROJECT_NAME} \
  --deployment-max-percent 200 \
  --deployment-min-healthy-percent 50 \
  --target-group-arn ${TARGET_GROUP_ARN} \
  --health-check-grace-period 30 \
  --container-name ${PROJECT_NAME}-app \
  --container-port 9460 \
  --create-log-groups

# 서비스 초기화
ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  service up \
  --cluster ${PROJECT_NAME}

ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  service scale 2 \
  --cluster ${PROJECT_NAME}

# 서비스 업데이트
ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  service up \
  --cluster ${PROJECT_NAME} --force-deployment

# 서비스 삭제
ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  service down \
  --cluster ${PROJECT_NAME} \
  down --cluster ${PROJECT_NAME}

# 클러스터 삭제
ecs-cli down --cluster ${PROJECT_NAME}