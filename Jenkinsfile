pipeline {
  
  environment {
    /*
    IMPORTANT!!! - Set the values for the following variables to match your environment.
    
    Note:  You must set up Jenkins credentials for the CONTAINER_REGISTRY_CREDENTIALS, SMART_CHECK_CREDENTIALS and KUBE_CONFIG variables.
    
    */
    GIT_REPO =                       "https://github.com/howie-howerton/jenkins-flask-tutorial.git"
    DOCKER_IMAGE_NAME =              "terraform-eks-demo"
    CONTAINER_REGISTRY =             "756757677343.dkr.ecr.us-east-1.amazonaws.com"
    CONTAINER_REGISTRY_CREDENTIALS = "aws-credentials2"
    SMART_CHECK_HOSTNAME =           "a463b12957bee11e9918a129842aafef-2100414139.us-east-1.elb.amazonaws.com"
    SMART_CHECK_CREDENTIALS =        "smart-check-jenkins-user"
    KUBE_CONFIG =                    "kubeconfig"
    KUBE_YML_FILE_IN_GIT_REPO =      "flask-docker-kube.yml"
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
          docker.withRegistry('https://$CONTAINER_REGISTRY', 'ecr:us-east-1:aws-credentials') {
          //dockerImage.push()
          docker.image('$DOCKER_IMAGE_NAME:$BUILD_NUMBER').push()
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
            ])
            {
                smartcheckScan([
                    imageName: "$CONTAINER_REGISTRY/$DOCKER_IMAGE_NAME:$BUILD_NUMBER",
                    smartcheckHost: "$SMART_CHECK_HOSTNAME",
                    insecureSkipTLSVerify: true,
                    smartcheckCredentialsId: SMART_CHECK_CREDENTIALS,
                    /*imagePullAuth: new groovy.json.JsonBuilder([
                        username: USER,
                        password: PASSWORD,
                    ]).toString(),*/
                    imagePullAuth: new groovy.json.JsonBuilder([
                      aws:[
                        region: "us-east-1",
                        accessKeyID: User,
                        secretAccessKey: Password,
                        role: "arn:aws:iam::756757677343:role/ECR_Policy",
                        externalID: "756757677343",
                        roleSessionName: "DeepSecuritySmartCheck",
                        registry: "756757677343",
                      ],
                    ]).toString(),
                    findingsThreshold: new groovy.json.JsonBuilder([
                        malware: 0,
                        vulnerabilities: [
                            defcon1: 0,
                            critical: 0,
                            high: 0,
                        ],
                        contents: [
                            defcon1: 0,
                            critical: 0,
                            high: 3,
                        ],
                        checklists: [
                            defcon1: 0,
                            critical: 0,
                            high: 0,
                        ],
                    ]).toString(),
                ])
              }
            }
        }
        

    stage ("Deploy to Cluster") {
      steps{
        //input 'Deploy to Kubernetes?'
        //milestone(1)
        kubernetesDeploy(
            kubeconfigId: KUBE_CONFIG,
            configs: KUBE_YML_FILE_IN_GIT_REPO,
            enableConfigSubstitution: true
        )
      }
    }
  }
}


/* this
   is a
   multi-line comment */

// this is a single line comment
