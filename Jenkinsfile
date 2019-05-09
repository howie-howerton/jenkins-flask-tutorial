pipeline {
  environment {
    // Set the values for the following variables to match your environment
    GIT_REPO = "https://github.com/howie-howerton/jenkins-flask-tutorial.git"
    IMAGE_BASE_NAME = "howiehowerton/flask-docker"
    CONTAINER_REGISTRY_URL = "https://registry.hub.docker.com"
    registryCredential = 'dockerhub login'
    DOCKER_IMAGE_NAME = 'howiehowerton/flask-docker'
  }

  agent any
  stages {
    stage("Cloning Git Repo") {
      steps {
        git "$GIT_REPO"
      }
    }

    stage("Building image") {
      steps{
        script {
          dockerImage = docker.build('$IMAGE_BASE_NAME:$BUILD_NUMBER')
        }
      }
    }

    stage("Stage Image") {
      steps{
        script {
          docker.withRegistry('$CONTAINER_REGISTRY_URL', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }

    stage("Smart Check Scan") {
        steps {
            withCredentials([
                usernamePassword([
                    credentialsId: registryCredential,
                    usernameVariable: "USER",
                    passwordVariable: "PASSWORD",
                ])             
            ]){            
                smartcheckScan([
                    imageName: "registry.hub.docker.com/howiehowerton/flask-docker:$BUILD_NUMBER",
                    smartcheckHost: "a5937bcc771bd11e988371653597d57e-214315904.us-east-1.elb.amazonaws.com",
                    insecureSkipTLSVerify: true,
                    smartcheckCredentialsId: "smart-check-jenkins-user",
                    imagePullAuth: new groovy.json.JsonBuilder([
                        username: USER,
                        password: PASSWORD,
                        ]).toString(),
                    ])
                }
            }
        }
        

    stage ("Deploy to Cluster") {
      steps{
        input 'Deploy to Kubernetes?'
        milestone(1)
        kubernetesDeploy(
            kubeconfigId: 'kubeconfig',
            configs: 'flask-docker-kube.yml',
            enableConfigSubstitution: true
        )
      }
    }
  }
}
