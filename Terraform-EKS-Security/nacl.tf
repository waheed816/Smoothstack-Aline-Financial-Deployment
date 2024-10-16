resource "aws_network_acl" "rds_nacl" {
  vpc_id = aws_vpc.vpc-mm.id
  tags = {
    Name = "rds-nacl"
  }
}

resource "aws_network_acl_rule" "deny_inbound_rds" {
  network_acl_id = aws_network_acl.rds_nacl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "deny"
  egress         = false
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "deny_outbound_rds" {
  network_acl_id = aws_network_acl.rds_nacl.id
  rule_number    = 101
  protocol       = "-1"
  rule_action    = "deny"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "subnet_association_1" {
  subnet_id      = aws_subnet.public-subnet-a-mm.id
  network_acl_id = aws_network_acl.rds_nacl.id
}

resource "aws_network_acl_association" "subnet_association_2" {
  subnet_id      = aws_subnet.public-subnet-b-mm.id
  network_acl_id = aws_network_acl.rds_nacl.id
}

resource "aws_network_acl_association" "subnet_association_3" {
  subnet_id      = aws_subnet.public-subnet-c-mm.id
  network_acl_id = aws_network_acl.rds_nacl.id
}
