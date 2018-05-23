#!/usr/bin/env bash
## ecr에다가 배포하는 스크립트
eval $(aws ecr get-login --no-include-email --region ap-northeast-2)

docker build -t ${PROJECT_NAME} .

docker tag ${PROJECT_NAME}:latest ${DEPLOY_IMAGE}:latest

docker push ${DEPLOY_IMAGE}:latest