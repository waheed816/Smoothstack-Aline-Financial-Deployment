# resource "aws_ecs_service" "user_micro" {
#   name            = "user-micro"
#   cluster         = aws_ecs_cluster.aline-ecs-cluster.id
#   task_definition = aws_ecs_task_definition.user_micro.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"
#   network_configuration {
#     subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]
#     security_groups = [aws_security_group.ecs_user_micro_sg.id]
#     assign_public_ip = true
#   }
#   deployment_controller {
#     type = "ECS"
#   }

#   service_connect_configuration {
#     enabled = true
#     namespace = aws_service_discovery_private_dns_namespace.app_namespace.name
#     service {
#         port_name      = "user-micro"
#         discovery_name = "user-micro"
#         client_alias {
#             port = 8070
#         }

#       }
#   }
# }

resource "aws_ecs_service" "user_micro_service" {
  name            = "user-micro-service"
  cluster         = aws_ecs_cluster.aline-ecs-cluster.id
  task_definition = aws_ecs_task_definition.user_micro.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]
    security_groups = [aws_security_group.ecs_user_micro_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.user.arn
    container_name   = "user-micro"
    container_port   = 8070
  }



  # service_registries {
  #   registry_arn = aws_service_discovery_service.user_micro_service.arn
  # }
}

# resource "aws_ecs_service" "admin_portal_service" {
#   name            = "admin-portal-service"
#   cluster         = aws_ecs_cluster.aline-ecs-cluster.id
#   task_definition = aws_ecs_task_definition.admin_portal.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]
#     security_groups = [aws_security_group.admin_portal_sg.id]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.admin_portal_target_group.arn
#     container_name   = "admin-portal"
#     container_port   = 3000
#   }
# }

# resource "aws_ecs_service" "admin_portal" {
#   name            = "admin-portal"
#   cluster         = aws_ecs_cluster.aline-ecs-cluster.id
#   task_definition = aws_ecs_task_definition.admin_portal.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"
#   network_configuration {
#     subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]
#     security_groups = [aws_security_group.admin_portal_sg.id]
#     assign_public_ip = true
#   }
#   deployment_controller {
#     type = "ECS"
#   }

#   service_connect_configuration {
#     enabled = true
#     namespace = aws_service_discovery_private_dns_namespace.app_namespace.name
#     service {
#         port_name      = "admin-portal"
#         discovery_name = "admin-portal"
#         client_alias {
#             port = 3000
#         }

#       }
#   }
# }



# resource "aws_ecs_service" "aline_gateway_service" {
#   name            = "aline-gateway-service"
#   cluster         = aws_ecs_cluster.aline-ecs-cluster.id
#   task_definition = aws_ecs_task_definition.aline_gateway.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]
#     security_groups = [aws_security_group.aline_gateway_sg.id]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.aline_gateway_target_group.arn
#     container_name   = "aline-gateway"
#     container_port   = 8080
#   }
# }


resource "aws_ecs_service" "aline_gateway_service" {
  name            = "gateway"
  cluster         = aws_ecs_cluster.aline-ecs-cluster.id
  task_definition = aws_ecs_task_definition.gateway.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]
    security_groups = [aws_security_group.aline_gateway_sg.id]
    assign_public_ip = true
  }


  # deployment_controller {
  #   type = "ECS"
  # }

  # service_connect_configuration{
  #   enabled = true
  #   namespace = aws_service_discovery_private_dns_namespace.app_namespace.name
  #   service {
  #       port_name      = "gateway"
  #       discovery_name = "gateway"
  #       client_alias {
  #           port = 8080
  #       }

  #     }
  # }
}
