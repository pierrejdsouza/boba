pipeline {
    agent any
    tools {
        nodejs "Node"
        terraform "Terraform"
    }

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('rga-sa')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'cd boba-app && npm install'
                sh 'cd boba-app && npm run build'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Deploy') {
            steps {
                sh 'gsutil -m rsync -r dist/ gs://97a2c0d787f823a2-boba-bucket/'
            }
        }
    }
}