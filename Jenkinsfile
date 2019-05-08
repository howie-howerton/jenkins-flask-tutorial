pipeline {
  environment {
    registry = "756757677343.dkr.ecr.us-east-1.amazonaws.com/flask-docker"
    registryCredential = 'awsCredentials'
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
          dockerImage = docker.build('756757677343.dkr.ecr.us-east-1.amazonaws.com/flask-docker:latest')
        }
      }
    }

    stage("Stage Image") {
      steps{
        script {
          docker.withRegistry('https://756757677343.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }

    stage("Smart Check Scan") {
        steps {
            echo "Figure this out!"
            }
        }
        

    stage ("Deploy to Cluster") {
      steps{
        echo "Function to be added at a later date."
      }
    }
  }
}
