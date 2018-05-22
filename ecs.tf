provider "aws" {
  region = "ap-northeast-2"
}

module "ecs" {
  source = "./modules"
}