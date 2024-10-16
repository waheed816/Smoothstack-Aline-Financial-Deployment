resource "aws_ecs_task_definition" "user_micro" {
  family                   = "user-micro"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  cpu                      = "512"
  memory                   = "2048"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "user-micro"
      image     = "767397723308.dkr.ecr.us-east-1.amazonaws.com/aline-financial-mm:user-micro-eks-v1"
      essential = true
      portMappings = [
        {
          containerPort = 8070
          hostPort      = 8070
          protocol      = "tcp"
          name          = "user-micro"
        }
      ]
      environment = [
        {
            name  = "DB_HOST"
            value = aws_db_instance.alineDBmm.address
        },
        {
            name  = "DB_NAME"
            value = "alineDBmm"
        },
        {
            name  = "DB_USERNAME"
            value = "aline_admin"
        },
        {
            name  = "DB_PASSWORD"
            value = "Aline123"
        },
        {
            name  = "DB_PORT"
            value = "3306"
        }
      ]
    #   serviceConnectConfiguration = {
    #     namespace = aws_service_discovery_private_dns_namespace.app_namespace.name
    #     services = [
    #       {
    #         portName      = "user-micro"
    #         discoveryName = "user-micro"
    #         clientAliases = [
    #           {
    #             port = 8070
    #           }
    #         ]
    #       }
    #     ]
    #   }
    }
  ])
}


# resource "aws_ecs_task_definition" "user_micro" {
#   family                   = "user-micro"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = aws_iam_role.ecs_task_execution.arn
# #   task_role_arn            = aws_iam_role.ecs_task.arn
#   cpu                      = "512"
#   memory                   = "2048"

#   runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture        = "ARM64"
#   }

#   container_definitions    = jsonencode([{
#         name      = "user-micro"
#         image     = "767397723308.dkr.ecr.us-east-1.amazonaws.com/aline-financial-mm:user-micro-eks-v1"
#         essential = true
#         portMappings = [{
#         containerPort = 8070
#         hostPort      = 8070
#         }]

#         environment = [
#             {
#                 name  = "DB_HOST"
#                 value = aws_db_instance.alineDBmm.address
#             },
#             {
#                 name  = "DB_NAME"
#                 value = "alineDBmm"
#             },
#             {
#                 name  = "DB_USERNAME"
#                 value = "aline_admin"
#             },
#             {
#                 name  = "DB_PASSWORD"
#                 value = "Aline123"
#             },
#             {
#                 name  = "DB_PORT"
#                 value = "3306"
#             }
#         ]

#         depends_on = [aws_db_instance.alineDBmm]
#     }])

# }


# resource "aws_ecs_task_definition" "admin_portal" {
#   family                   = "admin-portal"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = aws_iam_role.ecs_task_execution.arn
#   cpu                      = "512"
#   memory                   = "2048"
#   container_definitions    = jsonencode([{
#         name      = "admin-portal"
#         image     = "767397723308.dkr.ecr.us-east-1.amazonaws.com/aline-financial-mm:aline-admin-portal-ecs-aws-v1"
#         essential = true
#         portMappings = [{
#           containerPort = 3000
#           hostPort      = 3000
#           protocol      = "tcp"
#         }]
#     }])

#   runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture        = "ARM64"
#   }
# }

# resource "aws_ecs_task_definition" "admin_portal" {
#   family                   = "admin-portal"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = aws_iam_role.ecs_task_execution.arn
#   cpu                      = "512"
#   memory                   = "2048"
#   runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture        = "ARM64"
#   }
#   container_definitions = jsonencode([
#     {
#       name      = "admin-portal"
#       image     = "767397723308.dkr.ecr.us-east-1.amazonaws.com/aline-financial-mm:aline-admin-portal-tf-aws-v1"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 3000
#           hostPort      = 3000
#           protocol      = "tcp"
#           name          = "admin-portal"
#         }
#       ]
#     }
#   ])
# }



# resource "aws_ecs_task_definition" "aline_gateway" {
#   family                   = "aline-gateway"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = aws_iam_role.ecs_task_execution.arn
#   cpu                      = "512"
#   memory                   = "2048"
#   container_definitions    = jsonencode([{
#         name      = "aline-gateway"
#         image     = "767397723308.dkr.ecr.us-east-1.amazonaws.com/aline-financial-mm:aline_gateway-v10"
#         essential = true
#         portMappings = [{
#           containerPort = 8080
#         }]
#         environment = [
#             {
#                 name  = "APP_SERVICE_HOST"
#                 value = "app.internal3"
#             },
#             {
#                 name  = "PORTAL_LANDING"
#                 value = "http://portal.landing"
#             },
#             {
#                 name  = "PORTAL_DASHBOARD"
#                 value = "http://portal.dashboard"
#             },
#             {
#                 name  = "PORTAL_ADMIN"
#                 value = "http://${aws_lb.admin_portal_lb.dns_name}"
#             }
#         ]
#     }])

#   runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture        = "ARM64"
#   }
# }

resource "aws_ecs_task_definition" "gateway" {

  depends_on = [
    aws_lb.ecs_alb,
    aws_iam_role.ecs_task_execution,
    aws_iam_role.ecs_task
  ]

  family                   = "gateway"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  cpu                      = "512"
  memory                   = "1024"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "gateway"
      image     = "767397723308.dkr.ecr.us-east-1.amazonaws.com/aline-financial-mm:aline-gateway-ecs-tf-v1"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          name          = "gateway"
        }
      ]
      environment = [
        {
          name  = "APP_SERVICE_HOST"
          value = "http://${aws_lb.ecs_alb.dns_name}"
        },
        {
          name  = "PORTAL_LANDING"
          value = "*"
        },
        {
          name  = "PORTAL_DASHBOARD"
          value = "*"
        },
        {
          name  = "PORTAL_ADMIN"
          value = "*"
        }
      ]
    }
  ])
}
