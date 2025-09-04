resource "aws_db_subnet_group" "ruby_db_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.subnet_group_name
  }
}

resource "aws_rds_cluster" "rds_cluster_dev" {
  cluster_identifier = var.cluster_identifier
  engine             = var.engine
  engine_version     = var.engine_version
  storage_encrypted  = true
  kms_key_id         = var.key_arn

  #allow_major_version_upgrade = true
  #apply_immediately           = true

  availability_zones      = var.azs
  database_name           = var.rds_name
  master_username         = "admin"
  master_password         = "admin12345"
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.ruby_db_subnet_group.name
  vpc_security_group_ids  = var.db_sg
  monitoring_interval     = 0
  skip_final_snapshot     = true

  depends_on = [aws_db_subnet_group.ruby_db_subnet_group]
}

resource "aws_rds_cluster_instance" "rds_cluster_dev_instances" {
  count                           = var.instance_count
  identifier                      = "aurora-cluster-dev-${count.index}"
  cluster_identifier              = aws_rds_cluster.rds_cluster_dev.id
  instance_class                  = "db.t3.meduim"
  engine                          = aws_rds_cluster.rds_cluster_dev.engine
  engine_version                  = aws_rds_cluster.rds_cluster_dev.engine_version
  performance_insights_enabled    = true
  performance_insights_kms_key_id = var.key_arn
  kms_key_id                      = var.key_arn

  apply_immediately = true
}
