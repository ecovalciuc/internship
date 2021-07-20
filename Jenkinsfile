pipeline {
    environment {
        USER = "ecovalciuc-petclinic"
        VER_ID = "v_${BUILD_NUMBER}"
        AWS_REGION = "us-east-1"
        ECR_REPO = "315727832121.dkr.ecr.us-east-1.amazonaws.com"
        GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
        SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
    }
    
    agent {
        node {
            label 'Slave01'
        }
    }
  
    stages {

        // Building PetClinic App. From GitLab repository. Testing and Scaning the code using SonarQube
        stage('BUILDING and SCANNING') {
            when {
                branch 'master'
            }
            steps {
                echo '<--- <-- <-:__Build and Scan__:-> --> --->'
                withCredentials([string(credentialsId: 'SONARQUBE_TOKEN', variable: 'LOGIN_TOKEN')]) {
                    sh "docker build --build-arg LOGIN_TOKEN=${LOGIN_TOKEN} -t ${USER}:${VER_ID} ."
                }
            }
        }

        // Push image to ECR in AWS. Version should be the commit ID
        stage('PUSHING docker image') {
            when {
                branch 'master'
            }
            steps {
                echo '<--- <-- <-:__Pushing petClinic to ECR repository__:-> --> --->'
                script {
                    docker.withRegistry(
                        'https://315727832121.dkr.ecr.us-east-1.amazonaws.com',
                        'ecr:us-east-1:aws-ecr-cred') {
                            docker.image("${USER}:${VER_ID}").push("latest")
                            docker.image("${USER}:${VER_ID}").push("${VER_ID}_${SHORT_COMMIT}")
                        }
                }
            }
        }

        // Deployment job
        stage('DEPLOYMENT') {
            when {
                branch 'master'
            }
            steps {
                echo '<--- <-- <-:__Deployment Running__:-> --> --->'
                sh "sed -i s/latest/${VER_ID}_${SHORT_COMMIT}/g depl_java.yaml"
                // sh "kubectl delete -f ns_java.yaml"                      //use this command in case you are going to delete the namespace
                sh "kubectl apply -f ns_java.yaml"                          //create namepace using manifest
                sh "kubectl apply -f depl_java.yaml"                        //create deployment using manifest
                sh "kubectl get namespaces"                                 //shows all namespaces
                sh "kubectl get all -n ecovalciuc-java-prod"                //shows all resources
                sh "kubectl describe deployment -n ecovalciuc-java-prod"    //describes the deployment
            }
        }
    }

    // CleanUP Step
    post {
        always {
            echo '-> --> ---> -----> --------> -------------> --------------------->- CleanUP...'
            // cleanWs()
            sh 'docker images -a | grep -e "sec" -e "min"'
            sh 'docker system prune -f --filter "label=project=ecovalciuc-petclinic"'
            sh 'docker rmi ${USER}:${VER_ID}'
            sh 'docker rmi ${ECR_REPO}/${USER}:latest'
            sh 'docker rmi ${ECR_REPO}/${USER}:${VER_ID}_${SHORT_COMMIT}'
        }
    }
}
