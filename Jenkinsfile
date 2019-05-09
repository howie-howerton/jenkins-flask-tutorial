pipeline {
  environment {
    registry = "howiehowerton/flask-docker"
    registryCredential = 'dockerhub login'
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
            echo "test"
            }
        }
        

    stage ("Deploy to Cluster") {
      steps{
        echo "Function to be added at a later date."
      }
    }
  }
}
