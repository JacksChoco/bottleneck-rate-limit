resource "aws_elasticache_cluster" "redis" {
  cluster_id = "${var.environment}-redis"

  # replication_group_id = "${aws_elasticache_replication_group.redis.id}"

  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  port                 = 6379
  security_group_ids   = ["${module.security_group.security_group_id}"]
  subnet_group_name    = "${aws_elasticache_subnet_group.redis.name}"
}

# resource "aws_elasticache_replication_group" "redis" {
#   automatic_failover_enabled    = true
#   replication_group_id          = "${var.environment}"
#   replication_group_description = "test description"
#   node_type                     = "cache.t2.micro"
#   number_cache_clusters         = 2
#   parameter_group_name          = "default.redis3.2"
#   security_group_ids            = ["${module.security_group.security_group_id}"]
#   subnet_group_name             = "${aws_elasticache_subnet_group.redis.name}"
#   port                          = 6379

#   lifecycle {
#     ignore_changes = ["number_cache_clusters"]
#   }
# }

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = ["${var.subnet_ids}"]
}

module "security_group" {
  source = "../security_group"

  name                     = "${var.environment}_redis_security_group"
  environment              = "${var.environment}"
  vpc_id                   = "${var.vpc_id}"
  source_security_group_id = "${var.source_security_group_id}"
}
