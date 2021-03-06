module "k8s" {
  source = "../k8s"

  providers = {
    kubernetes = kubernetes
  }

  cluster   = var.cluster
  image     = "ddollar/fluentd:1.13"
  namespace = var.namespace
  rack      = var.rack

  target = templatefile("${path.module}/target.conf.tpl", {
    elasticsearch = var.elasticsearch,
    rack          = var.rack,
    syslog        = compact(split(",", var.syslog)),
  })
}
