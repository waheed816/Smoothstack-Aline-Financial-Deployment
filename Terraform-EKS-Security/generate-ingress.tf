locals {
  public_subnet_ids = join(",", [
    aws_subnet.public-subnet-a-mm.id,
    aws_subnet.public-subnet-b-mm.id,
    aws_subnet.public-subnet-c-mm.id
  ])

  depends_on = [
    aws_subnet.public-subnet-a-mm,
    aws_subnet.public-subnet-b-mm,
    aws_subnet.public-subnet-c-mm
  ]
}

resource "local_file" "ingress_yaml" {
  content = <<-EOF
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: aline-landing-portal-rules
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/group.name: ingress-mm
      alb.ingress.kubernetes.io/group.order: '10'
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 3007}]'
      alb.ingress.kubernetes.io/subnets: "${local.public_subnet_ids}"
  spec:
    ingressClassName: alb
    rules:
        - http:
            paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: landing-portal
                  port:
                    number: 3007
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: aline-admin-portal-rules
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/group.name: ingress-mm
      alb.ingress.kubernetes.io/group.order: '20'
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 3000}]'
      alb.ingress.kubernetes.io/subnets: "${local.public_subnet_ids}"
  spec:
    ingressClassName: alb
    rules:
        - http:
            paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: admin-portal
                  port:
                    number: 3000
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: aline-dashboard-rules
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/group.name: ingress-mm
      alb.ingress.kubernetes.io/group.order: '30'
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 4200}]'
      alb.ingress.kubernetes.io/subnets: "${local.public_subnet_ids}"
  spec:
    ingressClassName: alb
    rules:
        - http:
            paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: member-dashboard
                  port:
                    number: 4200
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: redirects
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/group.name: ingress-mm
      alb.ingress.kubernetes.io/group.order: '50'
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTP": 443}]'
      alb.ingress.kubernetes.io/subnets: "${local.public_subnet_ids}"
      alb.ingress.kubernetes.io/actions.landing-redirect: >
        {"type": "redirect", "redirectConfig": {"protocol":"HTTP", "host":"#{host}","port":"3007", "path": "/", "query":"","statusCode":"HTTP_302"}}
      alb.ingress.kubernetes.io/actions.admin-redirect: >
        {"type": "redirect", "redirectConfig": {"protocol":"HTTP", "host":"#{host}","port":"3000", "path": "/", "query":"","statusCode":"HTTP_302"}}
      alb.ingress.kubernetes.io/actions.login-redirect: >
        {"type": "redirect", "redirectConfig": {"protocol":"HTTP", "host":"#{host}","port":"4200", "path": "/", "query":"","statusCode":"HTTP_302"}}
  spec:
    ingressClassName: alb
    rules:
      - http:
          paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: landing-redirect
                  port:
                    name: use-annotation
            - path: /admin
              pathType: Prefix
              backend:
                service:
                  name: admin-redirect
                  port:
                    name: use-annotation
            - path: /login
              pathType: Prefix
              backend:
                service:
                  name: login-redirect
                  port:
                    name: use-annotation
  EOF

  filename = "${path.module}/../Kubernetes-Security/ingress.yaml"
}
