# data "aws_eks_cluster" "eks_cluster" {
#   name = "eks-cluster-mm"

#   depends_on = [aws_eks_cluster.eks-cluster-mm]
# }

# data "aws_eks_cluster_auth" "eks_cluster" {
#   name = data.aws_eks_cluster.eks_cluster.name

#   depends_on = [aws_eks_cluster.eks-cluster-mm]
# }

# data "aws_subnets" "public_subnets" {
#   filter {
#     name   = "tag:kubernetes.io/role/elb"
#     values = ["1"]
#   }

#   filter {
#     name   = "tag:kubernetes.io/cluster/${data.aws_eks_cluster.eks_cluster.name}"
#     values = ["shared"]
#   }

#   depends_on = [aws_eks_cluster.eks-cluster-mm]
# }

# resource "kubernetes_service" "gateway-mm" {
#   metadata {
#     name = "gateway-mm"

#     annotations = {
#       "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
#       "service.beta.kubernetes.io/aws-load-balancer-subnets" = join(",", data.aws_subnets.public_subnets.ids)
#     }
#   }

#   spec {
#     selector = {
#       app = "aline-gateway"
#     }

#     port {
#       protocol = "TCP"
#       port     = 8080
#       target_port = 8080
#     }

#     type = "LoadBalancer"
#   }

#   depends_on = [
#     data.aws_subnets.public_subnets
#   ]

# }


# resource "kubernetes_ingress_v1" "aline_landing_portal_rules" {
#   metadata {
#     name = "aline-landing-portal-rules"
#     annotations = {
#       "alb.ingress.kubernetes.io/scheme"            = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type"       = "ip"
#       "alb.ingress.kubernetes.io/group.name"        = "ingress-mm"
#       "alb.ingress.kubernetes.io/group.order"       = "10"
#       "alb.ingress.kubernetes.io/listen-ports"      = jsonencode([{"HTTP": 3007}])
#     }
#   }

#   spec {
#     ingress_class_name = "alb"

#     rule {
#       http {
#         path {
#           path     = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "landing-portal"
#               port {
#                 number = 3007
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "aline_admin_portal_rules" {
#   metadata {
#     name = "aline-admin-portal-rules"
#     annotations = {
#       "alb.ingress.kubernetes.io/scheme"            = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type"       = "ip"
#       "alb.ingress.kubernetes.io/group.name"        = "ingress-mm"
#       "alb.ingress.kubernetes.io/group.order"       = "20"
#       "alb.ingress.kubernetes.io/listen-ports"      = jsonencode([{"HTTP": 3000}])
#     }
#   }

#   spec {
#     ingress_class_name = "alb"

#     rule {
#       http {
#         path {
#           path     = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "admin-portal"
#               port {
#                 number = 3000
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "aline_dashboard_rules" {
#   metadata {
#     name = "aline-dashboard-rules"
#     annotations = {
#       "alb.ingress.kubernetes.io/scheme"            = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type"       = "ip"
#       "alb.ingress.kubernetes.io/group.name"        = "ingress-mm"
#       "alb.ingress.kubernetes.io/group.order"       = "30"
#       "alb.ingress.kubernetes.io/listen-ports"      = jsonencode([{"HTTP": 4200}])
#     }
#   }

#   spec {
#     ingress_class_name = "alb"

#     rule {
#       http {
#         path {
#           path     = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "member-dashboard"
#               port {
#                 number = 4200
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "redirects" {
#   metadata {
#     name = "redirects"
#     annotations = {
#       "alb.ingress.kubernetes.io/scheme"                            = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type"                       = "ip"
#       "alb.ingress.kubernetes.io/group.name"                        = "ingress-mm"
#       "alb.ingress.kubernetes.io/group.order"                       = "50"
#       "alb.ingress.kubernetes.io/listen-ports"                      = jsonencode([{"HTTP": 80}, {"HTTP": 443}])
#       "alb.ingress.kubernetes.io/actions.landing-redirect"          = jsonencode({"type": "redirect", "redirectConfig": {"protocol": "HTTP", "host": "#{host}", "port": "3007", "path": "/", "query": "", "statusCode": "HTTP_302"}})
#       "alb.ingress.kubernetes.io/actions.admin-redirect"            = jsonencode({"type": "redirect", "redirectConfig": {"protocol": "HTTP", "host": "#{host}", "port": "3000", "path": "/", "query": "", "statusCode": "HTTP_302"}})
#       "alb.ingress.kubernetes.io/actions.login-redirect"        = jsonencode({"type": "redirect", "redirectConfig": {"protocol": "HTTP", "host": "#{host}", "port": "4200", "path": "/", "query": "", "statusCode": "HTTP_302"}})
#     }
#   }

#   spec {
#     ingress_class_name = "alb"

#     rule {
#       http {
#         path {
#           path     = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "landing-redirect"
#               port {
#                 name = "use-annotation"
#               }
#             }
#           }
#         }

#         path {
#           path     = "/admin"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "admin-redirect"
#               port {
#                 name = "use-annotation"
#               }
#             }
#           }
#         }

#         path {
#           path     = "/login"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "login-redirect"
#               port {
#                 name = "use-annotation"
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
