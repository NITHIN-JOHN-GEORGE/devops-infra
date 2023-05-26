data "template_file" "jenkins" {
  template = <<EOF
controller:
  adminSecret: false
  adminUser: "${var.jenkinsUsername}"
  adminPassword: "${var.jenkinsPassword}"
  serviceType: LoadBalancer
  installPlugins:
    - kubernetes:3900.va_dce992317b_4
    - workflow-aggregator:596.v8c21c963d92d
    - git:5.0.0
    - configuration-as-code:1625.v27444588cc3d
  installLatestSpecifiedPlugins: true
  additionalPlugins: []
  # ingress:
  #   enabled: true
  #   # Override for the default paths that map requests to the backend
  #   paths: []
  #   # - backend:
  #   #     serviceName: ssl-redirect
  #   #     servicePort: use-annotation
  #   # - backend:
  #   #     serviceName: >-
  #   #       {{ template "jenkins.fullname" . }}
  #   #     # Don't use string here, use only integer value!
  #   #     servicePort: 8080
  #   # For Kubernetes v1.14+, use 'networking.k8s.io/v1beta1'
  #   # For Kubernetes v1.19+, use 'networking.k8s.io/v1'
  #   apiVersion: "networking.k8s.io/v1"
  #   labels: {}
  #   annotations: 
  #     kubernetes.io/ingress.class: nginx
  #   # kubernetes.io/tls-acme: "true"
  #   # For Kubernetes >= 1.18 you should specify the ingress-controller via the field ingressClassName
  #   # See https://kubernetes.io/blog/2020/04/02/improvements-to-the-ingress-api-in-kubernetes-1.18/#specifying-the-class-of-an-ingress
  #   # ingressClassName: nginx
  #   # Set this path to jenkinsUriPrefix above or use annotations to rewrite path
  #   # path: "/jenkins"
  #   # configures the hostname e.g. jenkins.example.com
  #   hostName:
  #   tls:
  #   # - secretName: jenkins.cluster.local
  #   #   hosts:
    #     - jenkins.cluster.local
persistence:
  enabled: true
  storageClass: ebs-sc
  accessMode: "ReadWriteOnce"
  size: "10Gi"
   EOF
}



resource "helm_release" "jenkins" {
  namespace        = "jenkins"
  create_namespace = true
  name                = "jenkins"
  repository          = "https://charts.jenkins.io"
  chart               = "jenkins"
  values = [data.template_file.jenkins.rendered]

  depends_on = [ aws_eks_cluster.eks-cluster , aws_eks_node_group.node-group-private ]

}