pipeline {
    agent any

    environment {
        FRONTEND_IMAGE = "vinayashreer/book-frontend:${BUILD_NUMBER}" // Use the correct frontend image name
        BACKEND_IMAGE  = "vinayashreer/book-backend:${BUILD_NUMBER}"  // Use the correct backend image name
    }

    stages {
        stage('Clone Repo') {
            steps {
                echo "Cloning repository..."
                git branch: 'main', url: 'https://github.com/vinayashree06/DevOpsP'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    echo "Building frontend Docker image..."
                    bat "docker build -t ${FRONTEND_IMAGE} ./book-review-app/frontend"

                    echo "Building backend Docker image..."
                    bat "docker build -t ${BACKEND_IMAGE} ./book-review-app/backend"
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        echo "Logging into DockerHub..."
                        bat "echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin"

                        echo "Pushing frontend image to DockerHub..."
                        bat "docker push ${FRONTEND_IMAGE}"

                        echo "Pushing backend image to DockerHub..."
                        bat "docker push ${BACKEND_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying frontend to Kubernetes..."
                    bat 'kubectl apply -f k8s/frontend-deployment.yaml'
                    bat 'kubectl apply -f k8s/frontend-service.yaml'

                    echo "Deploying backend to Kubernetes..."
                    bat 'kubectl apply -f k8s/backend-deployment.yaml'
                    bat 'kubectl apply -f k8s/backend-service.yaml'
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up local Docker images..."
            bat "docker rmi vinayashreer/book-frontend:${BUILD_NUMBER} || exit 0" // Clean up frontend image
            bat "docker rmi vinayashreer/book-backend:${BUILD_NUMBER} || exit 0"  // Clean up backend image
        }

        success {
            echo "Pipeline executed successfully!"
        }

        failure {
            echo "Pipeline failed. Please check logs."
        }
    }
}