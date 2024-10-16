resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "alineDBmm" {
  identifier             = "aline-db-mm"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "alineDBmm"
  username               = "aline_admin"
  password               = "Aline123"
  parameter_group_name   = "default.mysql8.0"
  publicly_accessible    = true
  vpc_security_group_ids = [module.rds-sg-mm.security_group_id]
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "alineDBmm"
  }
}

# data "aws_db_instance" "alineDBmm" {
#   db_instance_identifier = aws_db_instance.alineDBmm.id
# }
