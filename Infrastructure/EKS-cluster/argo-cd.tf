data "template_file" "argo-values" {
  template = <<EOF
dex:
  enabled: false 
redis-ha:
  enabled: false
controller:
  enableStatefulSet: true
server:
  extraArgs:
    - --insecure
  image:
    repository: argoproj/argocd
    tag: latest
    pullPolicy: IfNotPresent
  replicas: 2
  resources:
  containerPorts:
      server:  8080
  ingress:
    enabled: true
    ingressClassName: "alb"
    annotations:
      alb.ingress.kubernetes.io/group.name: argocd
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/backend-protocol: HTTP
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
      alb.ingress.kubernetes.io/target-type: ip
    hosts:
    - "argocd.example.io"
  ingressGrpc:
    enabled: true
    isAWSALB: true
    awsALB:
      serviceType: NodePort
      backendProtocolVersion: HTTP2
  service:
    type: NodePort
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