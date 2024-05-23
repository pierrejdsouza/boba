pipeline {
    agent any
    tools {
        nodejs "Node"
        terraform "Terraform"
    }

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('rga-sa')
        GIT_TOKEN = credentials('git-pat')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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

        stage('Build') {
            when { changeset "boba-app/**" }
            steps {
                sh 'cd boba-app && npm install'
                sh 'cd boba-app && npm run build'
            }
        }

        stage('Deploy') {
            when { changeset "boba-app/**" }
            steps {
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'cd boba-app && gsutil -m rsync -r dist/ gs://20240524-boba-bucket/'
            }
        }
    }
}