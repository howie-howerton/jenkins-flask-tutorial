pipeline {
  
  environment {
    /*
    IMPORTANT!!! - Set the values for the following environment variables to match your environment.
    
    Note:  You must set up *Jenkins credentials* for the following script variables:
    - CONTAINER_REGISTRY_CREDENTIALS (kind: AWS Credentials)
    - SMART_CHECK_CREDENTIALS (kind: Username with password)
    - AWS_ECR_READ_CREDENTIALS (kind: Username with password)
    - KUBE_CONFIG (kind: Secret text)
    
    */
    GIT_REPO =                       "https://github.com/howie-howerton/jenkins-flask-tutorial.git"
    DOCKER_IMAGE_NAME =              "flask-docker"
    CONTAINER_REGISTRY =             "756757677343.dkr.ecr.us-east-1.amazonaws.com"
    CONTAINER_REGISTRY_CREDENTIALS = "ecr-credentials"
    SMART_CHECK_HOSTNAME =           "https://internal-a52b4963e1b9511eaa8c7021541cc153-1403828315.us-east-1.elb.amazonaws.com"
    SMART_CHECK_CREDENTIALS =        "smart-check-jenkins-user"
    AWS_ECR_READ_CREDENTIALS =       "aws-ecr-read-credentials"
    PRE_REGISTRY_AUTH =              "preregistry-auth"
    //KUBE_CONFIG =                    "kubeconfig"
   // KUBE_YML_FILE_IN_GIT_REPO =      "flask-docker-kube.yml"
  }

  agent  any
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

    stage("Deep Security Smart Check scan") {
      steps {
        smartcheckScan([
            imageName: "$DOCKER_IMAGE_NAME:$BUILD_NUMBER",
            smartcheckHost: "$SMART_CHECK_HOSTNAME",
            smartcheckCredentialsId: SMART_CHECK_CREDENTIALS,
            preregistryScan: true,
            preregistryCredentialsId: PRE_REGISTRY_AUTH,
            insecureSkipTLSVerify: true
            ])
      }
    }
    
    stage("Stage Image in ECR") {
      steps{
        script {
          docker.withRegistry('https://$CONTAINER_REGISTRY', 'ecr:us-east-1:ecr-credentials' ) {
            dockerImage.push()
          }
        }
      }
    }

    stage ("Deploy to Cluster") {
      steps{
        echo "Deploying to Cluster..."
        //input 'Deploy to Kubernetes?'
        //milestone(1)
        //kubernetesDeploy(
         //   kubeconfigId: KUBE_CONFIG,
         //   configs: KUBE_YML_FILE_IN_GIT_REPO,
         //   enableConfigSubstitution: true
        //)
      }
    }
  }
}
