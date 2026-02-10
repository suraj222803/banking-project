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
    IMAGE_TAG    = "${BUILD_NUMBER}"

    // Terraform
    TF_IN_AUTOMATION = "true"
  }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  stages {

    /* =========================
       1️⃣ Checkout Source
       ========================= */
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    /* =========================
       2️⃣ Terraform Init
       ========================= */
    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh '''
            terraform init -reconfigure
          '''
        }
      }
    }

    /* =========================
       3️⃣ Terraform Validate
       ========================= */
    stage('Terraform Validate') {
      steps {
        dir('terraform') {
          sh '''
            terraform validate
          '''
        }
      }
    }

    /* =========================
       4️⃣ Terraform Apply
       ========================= */
    stage('Terraform Apply') {
      steps {
        dir('terraform') {
          sh '''
            terraform apply -auto-approve
          '''
        }
      }
    }

    /* =========================
       5️⃣ Configure kubectl
       ========================= */
    stage('Configure kubectl') {
      steps {
        sh '''
          aws eks update-kubeconfig \
            --region ${AWS_DEFAULT_REGION} \
            --name ${CLUSTER_NAME}
        '''
      }
    }

    /* =========================
       6️⃣ Build Docker Image
       ========================= */
    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t ${ECR_REPO}:${IMAGE_TAG} .
        '''
      }
    }

    /* =========================
       7️⃣ Push Image to ECR
       ========================= */
    stage('Push Image to ECR') {
      steps {
        sh '''
          aws ecr get-login-password --region ${AWS_DEFAULT_REGION} \
          | docker login \
            --username AWS \
            --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

          docker tag ${ECR_REPO}:${IMAGE_TAG} \
            ${ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}

          docker push \
            ${ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
        '''
      }
    }

    /* =========================
       8️⃣ Deploy to EKS (Helm)
       ========================= */
    stage('Deploy to EKS') {
      steps {
        sh '''
          helm upgrade --install banking-app helm/banking-app \
            --namespace banking \
            --create-namespace \
            --set image.repository=${ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO} \
            --set image.tag=${IMAGE_TAG}
        '''
      }
    }
  }

  post {
    success {
      echo '✅ Banking application deployed successfully'
    }
    failure {
      echo '❌ Pipeline failed — check logs'
    }
    always {
      cleanWs()
    }
  }
}
