pipeline {
  environment {
    // Set the values for the following variables to match your environment
    GIT_REPO = "https://github.com/howie-howerton/jenkins-flask-tutorial.git"
    DOCKER_IMAGE_NAME = "howiehowerton/flask-docker"
    CONTAINER_REGISTRY = "registry.hub.docker.com"
    CONTAINER_REGISTRY_CREDENTIALS = 'dockerhub login'
    SMART_CHECK_HOSTNAME = "a5937bcc771bd11e988371653597d57e-214315904.us-east-1.elb.amazonaws.com"
    SMART_CHECK_CREDENTIALS = "smart-check-jenkins-user"
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
          dockerImage = docker.build('$DOCKER_IMAGE_NAME:$BUILD_NUMBER')
        }
      }
    }

    stage("Stage Image") {
      steps{
        script {
          docker.withRegistry('https://$CONTAINER_REGISTRY', CONTAINER_REGISTRY_CREDENTIALS ) {
            dockerImage.push()
          }
        }
      }
    }

    stage("Smart Check Scan") {
        steps {
            withCredentials([
                usernamePassword([
                    credentialsId: CONTAINER_REGISTRY_CREDENTIALS,
                    usernameVariable: "USER",
                    passwordVariable: "PASSWORD",
                ])             
            ]){            
                smartcheckScan([
                    imageName: "$CONTAINER_REGISTRY/$DOCKER_IMAGE_NAME:$BUILD_NUMBER",
                    smartcheckHost: "$SMART_CHECK_HOSTNAME",
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
