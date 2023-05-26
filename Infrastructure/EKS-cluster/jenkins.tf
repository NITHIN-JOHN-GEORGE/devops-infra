data "template_file" "jenkins" {
  template = <<EOF
controller:

  adminSecret: true
  adminUser: "${var.jenkinsUsername}"
  adminPassword: "${var.jenkinsPassword}"

  servicePort: 80
  targetPort: 8080
  serviceType: ClusterIP

  # List of plugins to be install during Jenkins controller start
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

  # Set to false to download the minimum required version of all dependencies.
  installLatestPlugins: true

  # Set to true to download latest dependencies of any plugin that is requested to have the latest version.
  installLatestSpecifiedPlugins: true

 
  # Enable to initialize the Jenkins controller only once on initial installation.
  # Without this, whenever the controller gets restarted (Evicted, etc.) it will fetch plugin updates which has the potential to cause breakage.
  # Note that for this to work, `persistence.enabled` needs to be set to `true`
  initializeOnce: true

 
  JCasC:
    configScripts: 
      welcome-message: |
        jenkins:
          systemMessage: Welcome to our CI\CD server.  This Jenkins is configured and managed 'as code'.


  ingress:
    enabled: true
    apiVersion: "networking.k8s.io/v1"
    annotations: 
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/load-balancer-name: jenkins-lb
      alb.ingress.kubernetes.io/target-type: ip
    ingressClassName: "alb"


persistence:
  enabled: true
  storageClass:
  accessMode: "ReadWriteOnce"
  size: "8Gi"

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