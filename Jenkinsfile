pipeline {
    agent any
    tools {nodejs "Node"}

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = 'path/to/service-account-key.json'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'ls'
                sh 'npm install'
                sh 'npm run build'
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
                sh 'gsutil -m rsync -R dist/ gs://${BUCKET_NAME}'
            }
        }
    }
}