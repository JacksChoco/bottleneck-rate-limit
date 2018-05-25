#!/bin/sh
export PROJECT_NAME="bottleneck"
export TF_VAR_environment="bottleneck"
export AWS_ACCESS_KEY_ID=`aws configure get default.aws_access_key_id`
export AWS_SECRET_ACCESS_KEY=`aws configure get default.aws_secret_access_key`
export SECURITY_GROUP=`terraform output security_group_id`
export VPC=`terraform output vpc_id`
export SUBNET=${$(terraform output public_subnet_ids)[@]} # => array문을 join 시킬 수 있음 [1,2,3] => 1,2,3
export REGION="ap-northeast-2"
export INSTANCE_TYPE="t2.micro"
export KEY_PAIR="docker"
export TARGET_GROUP_ARN=`terraform output default_alb_target_group`
export DEPLOY_IMAGE=`terraform output ecr_url`
export AWS_ACCESS_KEY_ID=`aws --profile default configure get aws_access_key_id`
export AWS_SECRET_ACCESS_KEY=`aws --profile default configure get aws_secret_access_key`
export REDIS_HOST=`terraform output redis_address`