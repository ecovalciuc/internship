This is the project aimed to create CI/CD process for a Java Application. Spring PetClinic project was used for training purposes.

# CI/CD was implemented using:

### Jenkinsfile
Jenkins job type: multibranch pipeline
Jenkins settings: webhook triggered by pushing code, SCM checkout
Pipeline steps: Buiding and Scanning, Pushing tagged image to AWS ECR, Deploying app in EKS


### Dockerfile
Jenkinsfile uses Dockerfile for buid and scann
Dockerfile type - multistage build


### depl_java.yaml
This is Deplyment manifest file which is used by Jenkinsfile while Deploying the app. 


### ns_java.yaml
This file is used in Jenkinsfile for ECR namespace creation. A namespace once created using manifest file will be just checked for presence in the folowing running jobs. 


### deploy/Jenkinsfile
This jenkinsfile is used in deployment job and gives the posibility to revert to any version. Every image pushed to ECR was tagged by commit ID.


### The infrastructure was build in AWS by product owner and included the folowing instances:
- nginx
- jenkins master
- jenkins slave
- gitLab server
- SonarQube server
- ECR for images
- EKS for deployment

