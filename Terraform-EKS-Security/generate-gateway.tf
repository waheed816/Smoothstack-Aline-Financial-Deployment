resource "local_file" "gateway_yaml" {
  content = templatefile("${path.module}/gateway-template.yaml.tpl", {
    subnet_ids = join(",", [
      aws_subnet.public-subnet-a-mm.id,
      aws_subnet.public-subnet-b-mm.id,
      aws_subnet.public-subnet-c-mm.id
    ])
  })

  filename = "${path.module}/../Kubernetes-Security/gateway.yaml"

  depends_on = [
    aws_subnet.public-subnet-a-mm,
    aws_subnet.public-subnet-b-mm,
    aws_subnet.public-subnet-c-mm
  ]
}
