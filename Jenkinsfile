pipeline {
    agent any

    environment {
        FRONTEND_IMAGE = "vinaya/book-review-frontend"
        BACKEND_IMAGE  = "vinaya/book-review-backend"
    }

    stages {
        stage('Clone Repo') {
            steps {
               
                git branch: 'main', url: 'https://github.com/Vinaya/book-review-app.git'

            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh 'docker build -t $FRONTEND_IMAGE ./frontend'
                    sh 'docker build -t $BACKEND_IMAGE ./backend'
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh 'docker push $FRONTEND_IMAGE'
                        sh 'docker push $BACKEND_IMAGE'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f k8s/frontend-deployment.yaml'
                    sh 'kubectl apply -f k8s/frontend-service.yaml'
                    sh 'kubectl apply -f k8s/backend-deployment.yaml'
                    sh 'kubectl apply -f k8s/backend-service.yaml'
                }
            }
        }
    }
}
