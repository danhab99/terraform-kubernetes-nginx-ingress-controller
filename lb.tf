// https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.29.0/deploy/static/provider/aws/service-nlb.yaml
resource "kubernetes_service" "lb" {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/part-of"    = var.namespace
      "app.kubernetes.io/managed-by" = "terraform"
    }

    annotations = var.lb_annotations
  }

  spec {
    type = "LoadBalancer"
    selector = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.namespace
    }

    external_traffic_policy = "Local"

    dynamic "port" {
      for_each = local.lb_ports

      content {
        name        = port.value.name
        port        = port.value.port
        target_port = port.value.target_port
        protocol    = port.value.protocol
      }
    }
    load_balancer_source_ranges = var.load_balancer_source_ranges
  }
}
