data "template_file" "jenkins" {
  template = <<EOF

controller:
  adminUser: "${var.jenkinsUsername}"
  adminPassword: "${var.jenkinsPassword}"

   installPlugins:
     - kubernetes:3900.va_dce992317b_4
     - workflow-aggregator:596.v8c21c963d92d
     - git:5.0.0
     - configuration-as-code:1625.v27444588cc3d
     - blueocean
     - ws-cleanup
     - nodejs


persistence:
  enabled: true
  storageClass: ebs-sc
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