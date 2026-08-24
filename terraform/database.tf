resource "aws_db_subnet_group" "app" {
  name       = "p31-db-subnets"
  subnet_ids = aws_subnet.db[*].id
}

resource "aws_db_instance" "postgres" {
  identifier                 = "p31-postgres"
  engine                     = "postgres"
  instance_class             = var.db_instance_class
  allocated_storage          = 20
  max_allocated_storage      = 100
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  port                       = 5432
  db_subnet_group_name       = aws_db_subnet_group.app.name
  vpc_security_group_ids     = [aws_security_group.db.id]
  publicly_accessible        = false
  storage_encrypted          = true
  backup_retention_period    = 7
  deletion_protection        = false
  skip_final_snapshot        = true
  multi_az                   = true
  auto_minor_version_upgrade = true
}
