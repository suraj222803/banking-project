pipeline {
  agent any

  environment {
    AWS_REGION   = 'us-east-1'
    ACCOUNT_ID   = '039242531369'
    CLUSTER_NAME = 'banking-cluster'
    ECR_REPO     = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/banking-app"
  }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  stages {

    stage('Terraform Init & Apply') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws_access_key'
        ]]) {
          dir('terraform') {
            sh '''
              terraform --version
              terraform init -reconfigure
              terraform validate
              terraform apply -auto-approve -input=false
            '''
          }
        }
      }
    }

    stage('Wait for EKS Cluster') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws_access_key'
        ]]) {
          sh '''
            echo "⏳ Waiting for EKS cluster to become ACTIVE..."
            aws eks wait cluster-active \
              --name ${CLUSTER_NAME} \
              --region ${AWS_REGION}
          '''
        }
      }
    }

    stage('Update kubeconfig') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws_access_key'
        ]]) {
          sh '''
            aws eks update-kubeconfig \
              --region ${AWS_REGION} \
              --name ${CLUSTER_NAME}
          '''
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t banking-app:latest .
        '''
      }
    }

    stage('Login to ECR & Push Image') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws_access_key'
        ]]) {
          sh '''
            aws ecr get-login-password --region ${AWS_REGION} \
            | docker login --username AWS --password-stdin \
              ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

            docker tag banking-app:latest ${ECR_REPO}:latest
            docker push ${ECR_REPO}:latest
          '''
        }
      }
    }

    stage('Deploy via Helm') {
      steps {
        sh '''
          helm version
          helm upgrade --install banking-app helm/banking-app \
            --namespace banking \
            --create-namespace \
            --set image.repository=${ECR_REPO} \
            --set image.tag=latest
        '''
      }
    }
  }

  post {
    success {
      echo '✅ Banking application deployed successfully'
    }
    failure {
      echo '❌ Pipeline failed — check Jenkins logs'
    }
    always {
      cleanWs()
    }
  }
}
