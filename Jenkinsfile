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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker build -t $IMAGE_NAME .
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy with Terraform') {
            steps {
                dir('infra') {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        terraform init
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }
}
