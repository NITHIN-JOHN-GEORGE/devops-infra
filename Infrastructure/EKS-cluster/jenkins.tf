data "template_file" "jenkins" {
  template = <<EOF
jenkinsUser: "${var.jenkinsUsername}"
jenkinsPassword: "${var.jenkinsPassword}"
plugins: [blueocean,ws-cleanup,job-dsl,role-strategy,parameterized-trigger,nodejs,generic-webhook-trigger,credentials,credentials-binding]

persistence:
   enabled: true
   storageClass: "ebs-sc"
   size: 8Gi

   EOF
}

data "aws_ecrpublic_authorization_token" "token" {}


resource "helm_release" "jenkins" {
  namespace        = "jenkins"
  create_namespace = true
  name                = "jenkins"
  repository          = "oci://registry-1.docker.io/bitnamicharts/jenkins"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "jenkins"
  values = [data.template_file.jenkins.rendered]

  depends_on = [ aws_eks_cluster.eks-cluster , aws_eks_node_group.node-group-private ]

}