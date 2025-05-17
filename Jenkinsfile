pipeline {
    agent any

    environment {
        FRONTEND_IMAGE = "vinaya/book-review-frontend:%BUILD_NUMBER%"
        BACKEND_IMAGE  = "vinaya/book-review-backend:%BUILD_NUMBER%"
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
                    bat 'docker build -t vinaya/book-review-frontend:%BUILD_NUMBER% ./frontend'

                    echo "Building backend Docker image..."
                    bat 'docker build -t vinaya/book-review-backend:%BUILD_NUMBER% ./backend'
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        echo "Logging into DockerHub..."
                        bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'

                        echo "Pushing frontend image to DockerHub..."
                        bat 'docker push vinaya/book-review-frontend:%BUILD_NUMBER%'

                        echo "Pushing backend image to DockerHub..."
                        bat 'docker push vinaya/book-review-backend:%BUILD_NUMBER%'
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
            bat 'docker rmi vinaya/book-review-frontend:%BUILD_NUMBER% || exit 0'
            bat 'docker rmi vinaya/book-review-backend:%BUILD_NUMBER% || exit 0'
        }

        success {
            echo "Pipeline executed successfully!"
        }

        failure {
            echo "Pipeline failed. Please check logs."
        }
    }
}
