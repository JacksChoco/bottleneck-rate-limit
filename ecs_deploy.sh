#!/usr/bin/env bash
source ./bin/env.sh

ecs-cli compose --file deploy-compose.yml \
  --project-name ${PROJECT_NAME} \
  service up \
  --cluster ${PROJECT_NAME} --force-deployment