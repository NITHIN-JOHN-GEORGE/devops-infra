# Infrastructure:

Jenkins is Provisioned in EKS cluster via Helm chart and completely automated through Terraform 

Its exposed via Ingress Controller and Use EBS as storage class to create persistent volume. 

EKS Cluster with ALB ingress controller and EBS storage class is configured with Terraform.

Jenkins is Automatically provisioned and all required plugins are installed once EKS Cluster is created and no manual configuration needed.

![image](https://github.com/NITHIN-JOHN-GEORGE/node-js-ci-cd/assets/96073033/5807a3e1-5390-4d9c-bf17-24d92871ced8)

![image](https://github.com/NITHIN-JOHN-GEORGE/node-js-ci-cd/assets/96073033/8891bbff-8262-488c-9131-bdd097205e11)

![image](https://github.com/NITHIN-JOHN-GEORGE/node-js-ci-cd/assets/96073033/e64d08c9-507c-4815-995a-175f6628a59c)


![image](https://github.com/NITHIN-JOHN-GEORGE/node-js-ci-cd/assets/96073033/5f92e128-4bbe-4010-97e1-df3cbfbbbe11)

![image](https://github.com/NITHIN-JOHN-GEORGE/node-js-ci-cd/assets/96073033/32f75fc6-9065-484e-b562-e7805842a770)

# Setting Up Argo-CD via Helm and Terraform

![image](https://github.com/NITHIN-JOHN-GEORGE/node-js-ci-cd/assets/96073033/b2567e01-6197-4a88-9811-a8ae6272c1d2)


![image](https://github.com/NITHIN-JOHN-GEORGE/node-js-ci-cd/assets/96073033/b3214096-8cb5-4869-85a5-557198daf533)


![image](https://github.com/NITHIN-JOHN-GEORGE/node-js-ci-cd/assets/96073033/db15b330-238f-4427-a723-070336180d60)
