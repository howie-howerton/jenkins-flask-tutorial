pipeline {
  environment {
    registry = "howiehowerton/flask-docker"
    registryCredential = 'dockerhub login'
    DOCKER_IMAGE_NAME = 'howiehowerton/flask-docker'
  }

  agent any
  stages {
    stage("Cloning Git Repo") {
      steps {
        git "https://github.com/howie-howerton/jenkins-flask-tutorial.git"
      }
    }

    stage("Building image") {
      steps{
        script {
          dockerImage = docker.build('howiehowerton/flask-docker:latest')
        }
      }
    }

    stage("Stage Image") {
      steps{
        script {
          docker.withRegistry('https://registry.hub.docker.com', registryCredential ) {
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
                    imageName: "registry.hub.docker.com/howiehowerton/flask-docker:latest",
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
