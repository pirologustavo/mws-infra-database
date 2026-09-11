terraform {
  backend "s3" {
    bucket = "mws-terraform-state-2026"
    key    = "database/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "mws-rds-sg"
  description = "Security group para o RDS MySQL"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mws_mysql" {
  identifier           = "mws-db-rds-v2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "mws_db"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}