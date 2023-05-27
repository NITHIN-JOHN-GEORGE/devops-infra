# Infrastructure:

Jenkins is Provisioned in EKS cluster via Helm chart and completely automated through Terraform 

Its exposed via Ingress Controller and Use EBS as storage class to create persistent volume. 

EKS Cluster with ALB ingress controller and EBS storage class is configured with Terraform.

Jenkins is Automatically provisioned and all required plugins are installed once EKS Cluster is created and no manual configuration needed.

ArgoCD also deployed to K8s cluster through Helm chart

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/9a899ea5-0895-44de-bafc-792ab81b097f)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/c0130d07-08f6-4645-837c-8505eec5d7ee)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/4ab0910b-e1ea-4d18-acc1-6246d97fc63f)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/6a2a623f-9f71-4517-9b35-3379785b061a)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/56052aa6-43c2-4bce-bfca-a52544bee1e8)

# Setting Up Argo-CD via Helm and Terraform

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/e6d8559c-3225-45d5-a226-62d4dd9635f6)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/fa93a0a3-9374-4f85-9408-efde73bb01e5)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/15b9417d-071e-4da0-ad26-bc71728bd339)
