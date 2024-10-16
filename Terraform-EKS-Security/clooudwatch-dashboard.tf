resource "aws_cloudwatch_dashboard" "eks_cluster_dashboard_mm" {
  dashboard_name = "EKSClusterDashboardMM"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 12,
        y = 12,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/Logs", "IncomingLogEvents", "LogGroupName", "/aws/containerinsights/eks-cluster-mm/performance" ],
            [ ".", "IncomingBytes", ".", "/aws/containerinsights/eks-cluster-mm/performance" ],
          ],
          view = "timeSeries",
          stacked = false,
          region = "us-east-1",
          title = "EKS Incoming Log Events",
        }
      },
      {
        type = "metric",
        x = 0,
        y = 6,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${aws_db_instance.alineDBmm.identifier}" ],
            [ ".", "FreeStorageSpace", ".", "${aws_db_instance.alineDBmm.identifier}" ],
          ],
          view = "timeSeries",
          stacked = false,
          region = "us-east-1",
          title = "RDS Metrics",
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 0,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [ "ContainerInsights", "node_cpu_utilization", "ClusterName", "${aws_eks_cluster.eks-cluster-mm.name}" ],
            [ ".", "node_memory_utilization", ".", "${aws_eks_cluster.eks-cluster-mm.name}" ]
          ],
          "view": "timeSeries",
          "stacked": false,
          "region": "us-east-1",
          "title": "Node CPU & Memory Utilization"
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 12,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [ "ContainerInsights", "node_filesystem_utilization", "ClusterName", "${aws_eks_cluster.eks-cluster-mm.name}" ]
          ],
          "view": "timeSeries",
          "stacked": false,
          "region": "us-east-1",
          "title": "Node Disk Space Utilization"
        }
      },
      {
        "type": "metric",
        "x": 12,
        "y": 0,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${aws_db_instance.alineDBmm.identifier}" ]
          ],
          "view": "timeSeries",
          "stacked": false,
          "region": "us-east-1",
          "title": "Database Connections"
        }
      },
      {
        "type": "metric",
        "x": 12,
        "y": 6,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "${aws_db_instance.alineDBmm.identifier}" ],
            [ ".", "WriteLatency", ".", "${aws_db_instance.alineDBmm.identifier}" ]
          ],
          "view": "timeSeries",
          "stacked": false,
          "region": "us-east-1",
          "title": "Read/Write Latency"
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 24,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "<load_balancer_name>" ]
          ],
          "view": "timeSeries",
          "stacked": false,
          "region": "us-east-1",
          "title": "ELB Request Count"
        }
      },
    ]
  })
}
