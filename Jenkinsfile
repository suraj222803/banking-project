pipeline {
  agent any

  environment {
    // Jenkins Credentials
    AWS_ACCESS_KEY_ID     = credentials('Access_key_ID')
    AWS_SECRET_ACCESS_KEY = credentials('Secret_access_key')

    // AWS & Project Config
    AWS_REGION   = 'us-east-1'
    ACCOUNT_ID   = '934424429123'
    CLUSTER_NAME = 'banking-cluster'

    ECR_REPO = '934424429123.dkr.ecr.us-east-1.amazonaws.com/banking-app'
  }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  stages {

    stage('Terraform Init & Apply') {
      steps {
        dir('terraform') {
          sh '''
            terraform --version

            terraform init -reconfigure
            terraform validate
            terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Wait for EKS Cluster') {
      steps {
        sh '''
          echo "⏳ Waiting for EKS cluster to become ACTIVE..."
          aws eks wait cluster-active \
            --name ${CLUSTER_NAME} \
            --region ${AWS_REGION}
        '''
      }
    }

    stage('Update kubeconfig') {
      steps {
        sh '''
          aws eks update-kubeconfig \
            --region ${AWS_REGION} \
            --name ${CLUSTER_NAME}
        '''
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
        sh '''
          aws ecr get-login-password --region ${AWS_REGION} \
          | docker login --username AWS --password-stdin \
            ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

          docker tag banking-app:latest ${ECR_REPO}:latest
          docker push ${ECR_REPO}:latest
        '''
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
