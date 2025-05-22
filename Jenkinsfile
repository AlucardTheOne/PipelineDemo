pipeline {
    agent any

    environment {
        IMAGE_NAME = "alucardtheone/demo-app"
        AWS_REGION = "eu-north-1"
    }

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/AlucardTheOne/PipelineDemo.git'
            }
        }

        stage('Build') {
            steps {
                bat '"C:\\Program Files\\apache-maven-3.9.9\\bin\\mvn" clean package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    bat '''
                    echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    docker build -t %IMAGE_NAME% .
                    docker push %IMAGE_NAME%
                    '''
                }
            }
        }

        stage('Deploy with Terraform') {
            steps {
                dir('infra') {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'aws-credentials',
                            usernameVariable: 'AWS_ACCESS_KEY_ID',
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        bat '''
                        terraform init
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }
}
