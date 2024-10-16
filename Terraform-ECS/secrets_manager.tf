# resource "aws_secretsmanager_secret" "db_credentials" {
#   name = "aws-rds-secrets-ecs8"
# }

# resource "aws_secretsmanager_secret_version" "db_credentials" {
#   secret_id = aws_secretsmanager_secret.db_credentials.id
#   secret_string = jsonencode({
#     DB_HOST     = aws_db_instance.alineDBmm.endpoint,
#     DB_NAME     = "alineDBmm",
#     DB_USERNAME = "aline_admin",
#     DB_PASSWORD = "Aline123",
#     DB_PORT     = "3306",
#   })

#   depends_on = [aws_db_instance.alineDBmm]
# }
