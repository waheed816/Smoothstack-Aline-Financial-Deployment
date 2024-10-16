# Output for public subnet A
output "public_subnet_a_mm_id" {
  value = aws_subnet.public-subnet-a-mm.id
}

# Output for public subnet B
output "public_subnet_b_mm_id" {
  value = aws_subnet.public-subnet-b-mm.id
}

# Output for public subnet C
output "public_subnet_c_mm_id" {
  value = aws_subnet.public-subnet-c-mm.id
}

# Output all subnet IDs as a list
output "public_subnet_ids" {
  value = join(",", [
    aws_subnet.public-subnet-a-mm.id,
    aws_subnet.public-subnet-b-mm.id,
    aws_subnet.public-subnet-c-mm.id
  ])
}
