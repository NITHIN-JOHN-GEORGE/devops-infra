data "template_file" "argo-values" {
  template = <<EOF
dex:
  enabled: false 
redis-ha:
  enabled: false
server:
  extraArgs:
    - --insecure
  containerPorts:
      server:  8080
  service:
    type: LoadBalancer
  serviceAccount:
    create: true
    name: argocd-server
    automountServiceAccountToken: true
EOF
}

resource "helm_release" "argocd" {

  depends_on = [helm_release.alb-ingress-controller] 
  name  = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "4.9.7"
  create_namespace = true

  values = [data.template_file.argo-values.rendered]

}