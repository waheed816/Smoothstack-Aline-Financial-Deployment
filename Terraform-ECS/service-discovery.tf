# resource "aws_service_discovery_private_dns_namespace" "app_namespace" {
#   name        = "app.internal6"
#   vpc         = aws_vpc.main.id
#   description = "Private DNS namespace for application"
# }

# resource "aws_service_discovery_service" "user_micro_service" {
#   name = "user-micro-service"
#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.app_namespace.id
#     dns_records {
#       type = "A"
#       ttl  = 60
#     }
#     routing_policy = "MULTIVALUE"
#   }
#   health_check_custom_config {
#     failure_threshold = 1
#   }
# }
