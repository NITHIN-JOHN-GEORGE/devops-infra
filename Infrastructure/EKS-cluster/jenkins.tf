data "template_file" "jenkins" {
  template = <<EOF
controller:
  adminSecret: true
  adminUser: "${var.jenkinsUsername}"
  adminPassword: "${var.jenkinsPassword}"
  servicePort:80
  serviceType: ClusterIP
  installPlugins:
    - kubernetes:3923.v294a_d4250b_91
    - workflow-aggregator:596.v8c21c963d92d
    - git:5.0.2
    - configuration-as-code:1625.v27444588cc3d
    - nodejs:1.6.0
    - credentials:1236.v31e44e6060c0
    - credentials-binding:604.vb_64480b_c56ca_
    - saferestart:0.7
    - generic-webhook-trigger:1.86.3
    - postbuild-task:1.9
    - blueocean:1.27.4
    - ws-cleanup:0.45
    - role-strategy:633.v836e5b_3e80a_5
    - job-dsl:1.83


  installLatestSpecifiedPlugins: true
  additionalPlugins: []

  JCasC:
    defaultConfig: true
    configScripts:
      welcome-message: |
       jenkins:
         systemMessage: Welcome to our CI\CD server.  This Jenkins is configured and managed 'as code'.


  ingress:
    enabled: true
    paths: 
     - backend:
         serviceName: jenkins
         servicePort: 80

    apiVersion: "networking.k8s.io/v1"
    ingressClassName: "alb"
    annotations: |
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/load-balancer-name: vault-lb
      alb.ingress.kubernetes.io/target-type: ip

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