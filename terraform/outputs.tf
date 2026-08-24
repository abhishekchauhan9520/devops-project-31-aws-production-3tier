output "alb_dns_name" { value = aws_lb.app.dns_name }
output "vpc_id" { value = aws_vpc.main.id }
output "rds_endpoint" { value = aws_db_instance.postgres.address sensitive = true }
output "s3_bucket" { value = aws_s3_bucket.app.bucket }
