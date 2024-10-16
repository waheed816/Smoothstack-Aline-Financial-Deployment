resource "aws_db_instance" "alineDBmm" {
  identifier             = "aline-db-mm"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  db_name                = "alineDBmm"
  instance_class         = "db.t3.micro"
  username               = "aline_admin"
  password               = "Aline123"
  parameter_group_name   = aws_db_parameter_group.my_mysql_parameter_group_mm.name
  publicly_accessible    = true
  vpc_security_group_ids = [module.rds_sg_mm.security_group_id]
  skip_final_snapshot    = true
  db_subnet_group_name = aws_db_subnet_group.rds-subnet-group-mm.name
}

resource "aws_db_parameter_group" "my_mysql_parameter_group_mm" {
  name   = "my-mysql-parameter-group-mm"
  family = "mysql8.0"

  parameter {
    name  = "max_connections"
    value = "100"
  }

}

resource "aws_db_subnet_group" "rds-subnet-group-mm" {
  name       = "rds-subnet-group-mm"
  subnet_ids = [
    aws_subnet.public-subnet-a-mm.id,
    aws_subnet.public-subnet-b-mm.id,
    aws_subnet.public-subnet-c-mm.id
  ]
  tags = {
    Name = "rds-subnet-group-mm"
  }
}
