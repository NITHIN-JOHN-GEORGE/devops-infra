Pipeline FLow: ( Each job running as a K8s pod and once finished it will terminate the pod )


1. Developer Commits the Code to main branch
2. Webhook triggers Jenkins when there is a change in the code
3. Job is only build when theres a commit in main branch ( achieved with generic webhook )
4. Cloning the Application Repo and Devops Repo ( where we have the delivarables )
5. Removing other unwanted directories which are not specific to Deployment from Devops Repo
6. Build Docker Image with Kaniko and pushing to private ECR repo with custom tagging ( branch_name-commit_id-build_number )
7. Updating the deployment.yaml with new image
8. Pushing the new deployment.yaml to Devops/Delivarables with commit message , so ArgoCD can take place in deployment
9. Argocd Detects the change and deploys to the K8s cluster

# Creating ECR registry for docker registry

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/ecdca86e-0bb9-4bdb-99e0-a3a89b3ee689)

# Creating Kuberenets secret for Authentication ( for kaniko container )

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/c9085730-79ae-4553-82c3-a79fb3534db5)

# Adding Token to the Webhook Trigger

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/faa6e888-bbeb-4c53-a847-045a5addf409)

# Adding the Webhook

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/50b74ee2-c0f1-44a9-885f-b544dfdcfd4e)

# Adding conditions to trigger only when commit to main branch

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/5c7bcd08-6dc3-4b51-bdea-e90cd872af85)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/f6c4dbc3-43eb-4b84-bfab-870ef6916826)

# Testing the CI functionality

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/8671da9d-4014-4a43-8ee5-2c99e6442bfd)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/84d8b06f-e46f-486b-b5df-b85ed5b5a916)

Console Output

```
Generic Cause
[Pipeline] Start of Pipeline
[Pipeline] podTemplate
[Pipeline] {
[Pipeline] node
Created Pod: kubernetes jenkins/node-js-pipeline-49-m8zdr-0w7qz-2fskb
Agent node-js-pipeline-49-m8zdr-0w7qz-2fskb is provisioned from template node-js-pipeline_49-m8zdr-0w7qz
---
apiVersion: "v1"
kind: "Pod"
metadata:
  annotations:
    buildUrl: "http://jenkins.jenkins.svc.cluster.local:80/job/node-js-pipeline/49/"
    runUrl: "job/node-js-pipeline/49/"
  labels:
    app: "nodejs"
    jenkins/jenkins-jenkins-agent: "true"
    jenkins/label-digest: "a6ce1d57e40fd6595873bf4165285e98676a25d9"
    jenkins/label: "node-js-pipeline_49-m8zdr"
  name: "node-js-pipeline-49-m8zdr-0w7qz-2fskb"
  namespace: "jenkins"
spec:
  containers:
  - command:
    - "cat"
    image: "node:16-alpine3.16"
    name: "nodejs"
    tty: true
    volumeMounts:
    - mountPath: "/home/jenkins/agent"
      name: "workspace-volume"
      readOnly: false
  - command:
    - "cat"
    image: "bitnami/git:latest"
    name: "git"
    tty: true
    volumeMounts:
    - mountPath: "/home/jenkins/agent"
      name: "workspace-volume"
      readOnly: false
  - command:
    - "cat"
    image: "busybox:latest"
    name: "busybox"
    tty: true
    volumeMounts:
    - mountPath: "/home/jenkins/agent"
      name: "workspace-volume"
      readOnly: false
  - command:
    - "cat"
    image: "gcr.io/kaniko-project/executor:debug"
    name: "kaniko"
    tty: true
    volumeMounts:
    - mountPath: "/kaniko/.docker"
      name: "kaniko-secret"
    - mountPath: "/home/jenkins/agent"
      name: "workspace-volume"
      readOnly: false
  - env:
    - name: "JENKINS_SECRET"
      value: "********"
    - name: "JENKINS_TUNNEL"
      value: "jenkins-agent.jenkins.svc.cluster.local:50000"
    - name: "JENKINS_AGENT_NAME"
      value: "node-js-pipeline-49-m8zdr-0w7qz-2fskb"
    - name: "JENKINS_NAME"
      value: "node-js-pipeline-49-m8zdr-0w7qz-2fskb"
    - name: "JENKINS_AGENT_WORKDIR"
      value: "/home/jenkins/agent"
    - name: "JENKINS_URL"
      value: "http://jenkins.jenkins.svc.cluster.local:80/"
    image: "jenkins/inbound-agent:3107.v665000b_51092-5"
    name: "jnlp"
    resources:
      requests:
        memory: "256Mi"
        cpu: "100m"
    volumeMounts:
    - mountPath: "/home/jenkins/agent"
      name: "workspace-volume"
      readOnly: false
  nodeSelector:
    kubernetes.io/os: "linux"
  restartPolicy: "Never"
  volumes:
  - name: "kaniko-secret"
    secret:
      items:
      - key: ".dockerconfigjson"
        path: "config.json"
      secretName: "regcred"
  - emptyDir:
      medium: ""
    name: "workspace-volume"

Running on node-js-pipeline-49-m8zdr-0w7qz-2fskb in /home/jenkins/agent/workspace/node-js-pipeline
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Code checkout)
[Pipeline] script
[Pipeline] {
[Pipeline] container
[Pipeline] {
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
Warning: JENKINS-30600: special launcher org.csanchez.jenkins.plugins.kubernetes.pipeline.ContainerExecDecorator$1@72f76f7d; decorates RemoteLauncher[hudson.remoting.Channel@4270aacf:JNLP4-connect connection from ip-10-1-209-178.ec2.internal/10.1.209.178:60510] will be ignored (a typical symptom is the Git executable not being run inside a designated container)
Cloning the remote Git repository
Cloning repository https://github.com/NITHIN-JOHN-GEORGE/node-js-hello-world.git
 > git init /home/jenkins/agent/workspace/node-js-pipeline # timeout=10
Fetching upstream changes from https://github.com/NITHIN-JOHN-GEORGE/node-js-hello-world.git
 > git --version # timeout=10
 > git --version # 'git version 2.30.2'
 > git fetch --tags --force --progress -- https://github.com/NITHIN-JOHN-GEORGE/node-js-hello-world.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url https://github.com/NITHIN-JOHN-GEORGE/node-js-hello-world.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
Checking out Revision 317db6a9a3f15cc2e768ce2436dbe966879de468 (refs/remotes/origin/main)
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 317db6a9a3f15cc2e768ce2436dbe966879de468 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b main 317db6a9a3f15cc2e768ce2436dbe966879de468 # timeout=10
Commit message: "Update Readme.MD"
 > git rev-list --no-walk c72e3cd7758d2404791af62b89dbfe5d565c83fd # timeout=10
[Pipeline] sh
+ git config --global --add safe.directory /home/jenkins/agent/workspace/node-js-pipeline
[Pipeline] sh
+ git rev-parse --short=10 HEAD
[Pipeline] sh
+ git rev-parse --abbrev-ref HEAD
[Pipeline] }
[Pipeline] // container
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (OpsFile checkout)
[Pipeline] ws
Running in /home/jenkins/agent/workspace/node-js-pipeline/devops
[Pipeline] {
[Pipeline] container
[Pipeline] {
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
Warning: JENKINS-30600: special launcher org.csanchez.jenkins.plugins.kubernetes.pipeline.ContainerExecDecorator$1@1a034ec2; decorates RemoteLauncher[hudson.remoting.Channel@4270aacf:JNLP4-connect connection from ip-10-1-209-178.ec2.internal/10.1.209.178:60510] will be ignored (a typical symptom is the Git executable not being run inside a designated container)
Cloning the remote Git repository
Cloning repository https://github.com/NITHIN-JOHN-GEORGE/devops-infra.git
 > git init /home/jenkins/agent/workspace/node-js-pipeline/devops # timeout=10
Fetching upstream changes from https://github.com/NITHIN-JOHN-GEORGE/devops-infra.git
 > git --version # timeout=10
 > git --version # 'git version 2.30.2'
 > git fetch --tags --force --progress -- https://github.com/NITHIN-JOHN-GEORGE/devops-infra.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
Checking out Revision ee6d4e0eab15cf5b7cc92d644957c93766ac0f83 (refs/remotes/origin/main)
Commit message: "Modified Deployment file with c72e3cd775"
 > git config remote.origin.url https://github.com/NITHIN-JOHN-GEORGE/devops-infra.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f ee6d4e0eab15cf5b7cc92d644957c93766ac0f83 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b main ee6d4e0eab15cf5b7cc92d644957c93766ac0f83 # timeout=10
 > git rev-list --no-walk 53b15f8ee3a494050f38b41571415a7c4ef3dc30 # timeout=10
[Pipeline] }
[Pipeline] // container
[Pipeline] }
[Pipeline] // ws
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Cleaning Up !!)
[Pipeline] script
[Pipeline] {
[Pipeline] container
[Pipeline] {
[Pipeline] sh
+ rm -rf /home/jenkins/agent/workspace/node-js-pipeline/devops/Infrastructure
[Pipeline] sh
+ rm -rf /home/jenkins/agent/workspace/node-js-pipeline/devops/README.md
[Pipeline] }
[Pipeline] // container
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build Docker Image & Push to ECR)
[Pipeline] script
[Pipeline] {
[Pipeline] container
[Pipeline] {
[Pipeline] sh
+ /kaniko/executor --context /home/jenkins/agent/workspace/node-js-pipeline --destination 365825155295.dkr.ecr.us-east-1.amazonaws.com/node-app:main-317db6a9a3-49
[36mINFO[0m[0000] Retrieving image manifest node:16.20.0-alpine3.16 
[36mINFO[0m[0000] Retrieving image node:16.20.0-alpine3.16 from registry index.docker.io 
[36mINFO[0m[0000] Built cross stage deps: map[]                
[36mINFO[0m[0000] Retrieving image manifest node:16.20.0-alpine3.16 
[36mINFO[0m[0000] Returning cached image manifest              
[36mINFO[0m[0000] Executing 0 build triggers                   
[36mINFO[0m[0000] Building stage 'node:16.20.0-alpine3.16' [idx: '0', base-idx: '-1'] 
[36mINFO[0m[0000] Unpacking rootfs as cmd COPY package.json ./ requires it. 
[36mINFO[0m[0002] WORKDIR /usr/src/app                         
[36mINFO[0m[0002] Cmd: workdir                                 
[36mINFO[0m[0002] Changed working directory to /usr/src/app    
[36mINFO[0m[0002] Creating directory /usr/src/app with uid -1 and gid -1 
[36mINFO[0m[0002] Taking snapshot of files...                  
[36mINFO[0m[0002] COPY package.json ./                         
[36mINFO[0m[0002] Taking snapshot of files...                  
[36mINFO[0m[0002] RUN npm install                              
[36mINFO[0m[0002] Initializing snapshotter ...                 
[36mINFO[0m[0002] Taking snapshot of full filesystem...        
[36mINFO[0m[0003] Cmd: /bin/sh                                 
[36mINFO[0m[0003] Args: [-c npm install]                       
[36mINFO[0m[0003] Running: [/bin/sh -c npm install]            

added 58 packages, and audited 59 packages in 2s

8 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
npm notice 
npm notice New major version of npm available! 8.19.4 -> 9.6.7
npm notice Changelog: <https://github.com/npm/cli/releases/tag/v9.6.7>
npm notice Run `npm install -g npm@9.6.7` to update!
npm notice 
[36mINFO[0m[0006] Taking snapshot of full filesystem...        
[36mINFO[0m[0007] COPY . .                                     
[36mINFO[0m[0007] Taking snapshot of files...                  
[36mINFO[0m[0007] EXPOSE 3000                                  
[36mINFO[0m[0007] Cmd: EXPOSE                                  
[36mINFO[0m[0007] Adding exposed port: 3000/tcp                
[36mINFO[0m[0007] CMD [ "npm", "start" ]                       
[36mINFO[0m[0007] Pushing image to 365825155295.dkr.ecr.us-east-1.amazonaws.com/node-app:main-317db6a9a3-49 
[36mINFO[0m[0008] Pushed 365825155295.dkr.ecr.us-east-1.amazonaws.com/node-app@sha256:47124517a3e5183f0c15a082bd2c88153a280d418bba225dd01c64020a2bfb94 
[Pipeline] }
[Pipeline] // container
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Updating Kubernetes deployment file)
[Pipeline] script
[Pipeline] {
[Pipeline] container
[Pipeline] {
[Pipeline] sh
+ sed -i 's|365825155295\.dkr\.ecr\.us-east-1\.amazonaws\.com/node-app:.*|365825155295.dkr.ecr.us-east-1.amazonaws.com/node-app:main-317db6a9a3-49|g' /home/jenkins/agent/workspace/node-js-pipeline/devops/deliverables/deployment.yml
[Pipeline] sh
+ cat /home/jenkins/agent/workspace/node-js-pipeline/devops/deliverables/deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeapp-deployment
  labels:
    app: nodeapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nodeapp
  template:
    metadata:
      labels:
        app: nodeapp 
    spec:
      containers:
      - name: nodeapp
        image: 365825155295.dkr.ecr.us-east-1.amazonaws.com/node-app:main-317db6a9a3-49
        ports:
        - containerPort: 3000
[Pipeline] }
[Pipeline] // container
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Pushing the New Changes to Deployment.yml file)
[Pipeline] script
[Pipeline] {
[Pipeline] dir
Running in /home/jenkins/agent/workspace/node-js-pipeline/devops/deliverables
[Pipeline] {
[Pipeline] container
[Pipeline] {
[Pipeline] withCredentials
Masking supported pattern matches of $pass
[Pipeline] {
[Pipeline] sh
Warning: A secret was passed to "sh" using Groovy String interpolation, which is insecure.
		 Affected argument(s) used the following variable(s): [pass]
		 See https://jenkins.io/redirect/groovy-string-interpolation for details.
+ git config --global --add safe.directory /home/jenkins/agent/workspace/node-js-pipeline/devops
+ git status
On branch main
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/Readme.MD
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/alb-ingress-ebs-csi-driver.tf
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/argo-cd.tf
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/data.tf
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/iam.tf
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/jenkins.tf
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/main.tf
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/variables.tf
	deleted:    ../Infrastructure/EKS-cluster-Jenkins-ArgoCD-Automation/versions.tf
	deleted:    ../Infrastructure/Readme.MD
	deleted:    ../Infrastructure/VPC/Readme.MD
	deleted:    ../Infrastructure/VPC/main.tf
	deleted:    ../Infrastructure/VPC/output.tf
	deleted:    ../Infrastructure/VPC/variables.tf
	deleted:    ../Infrastructure/VPC/versions.tf
	deleted:    ../README.md
	modified:   deployment.yml

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	../deliverables@tmp/

no changes added to commit (use "git add" and/or "git commit -a")
+ git add deployment.yml
+ git config --global user.name nithin
+ git config --global user.email nithinjohn97@gmail.com
+ git commit -m Modified Deployment file with 317db6a9a3
[main 2b90aa8] Modified Deployment file with 317db6a9a3
 1 file changed, 1 insertion(+), 1 deletion(-)
+ git remote set-url origin https://****@github.com/NITHIN-JOHN-GEORGE/devops-infra.git
+ git push origin main
remote: Resolving deltas:   0% (0/3)        
remote: Resolving deltas:  33% (1/3)        
remote: Resolving deltas:  66% (2/3)        
remote: Resolving deltas: 100% (3/3)        
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.        
To https://github.com/NITHIN-JOHN-GEORGE/devops-infra.git
   ee6d4e0..2b90aa8  main -> main
[Pipeline] }
[Pipeline] // withCredentials
[Pipeline] }
[Pipeline] // container
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] }
[Pipeline] // podTemplate
[Pipeline] End of Pipeline
Finished: SUCCESS

```

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/66d44f35-761f-4b1d-8105-ec265cebdff9)


![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/8238be2d-a4d3-4a82-9e5b-8122954c6391)


![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/3b63f62e-4c45-4313-865c-744bd3b6cb6d)

## ArgoCD

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/b45b69f5-0ec9-433f-815c-3e2ec0d0fa7b)


![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/5144b7e1-ace6-4bb1-bb2c-ae6c173ae5a7)


![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/833d9b3d-f44b-48a9-833d-d04cd434f06c)

# Response:

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/b9d2544c-decf-48ac-937d-bf316ff02507)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/9a9ac182-cb09-4644-80d6-f0d2f517579b)

![image](https://github.com/NITHIN-JOHN-GEORGE/devops-infra/assets/96073033/dec79d2f-67ca-4a50-9ee9-8ffa67727b51)
