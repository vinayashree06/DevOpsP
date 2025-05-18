pipeline {
    agent any

    environment {
        FRONTEND_IMAGE = "vinayashreer/book-frontend:${BUILD_NUMBER}"
        BACKEND_IMAGE  = "vinayashreer/book-backend:${BUILD_NUMBER}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "📦 Cloning repository from GitHub..."
                git branch: 'main', url: 'https://github.com/vinayashree06/DevOpsP'

                echo "📂 Listing workspace files..."
                bat "dir"
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    echo "🐳 Building frontend Docker image..."
                    bat "docker build -t ${FRONTEND_IMAGE} ./frontend"

                    echo "🐳 Building backend Docker image..."
                    bat "docker build -t ${BACKEND_IMAGE} ./backend"
                }
            }
        }

        stage('Push Docker Images to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        echo "🔐 Logging into DockerHub..."
                        bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"

                        echo "📤 Pushing frontend image to DockerHub..."
                        bat "docker push ${FRONTEND_IMAGE}"

                        echo "📤 Pushing backend image to DockerHub..."
                        bat "docker push ${BACKEND_IMAGE}"

                        echo "🔒 Logging out from DockerHub..."
                        bat "docker logout"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "🚀 Deploying frontend to Kubernetes..."
                    bat 'kubectl apply -f k8s/frontend-deployment.yaml'
                    bat 'kubectl apply -f k8s/frontend-service.yaml'

                    echo "🚀 Deploying backend to Kubernetes..."
                    bat 'kubectl apply -f k8s/backend-deployment.yaml'
                    bat 'kubectl apply -f k8s/backend-service.yaml'

                    // Optional: Ensure imagePullPolicy is Always in YAMLs for fresh pulls
                }
            }
        }
    }

    post {
        always {
            echo "🧹 Cleaning up local Docker images..."
            bat "docker rmi ${FRONTEND_IMAGE} || exit 0"
            bat "docker rmi ${BACKEND_IMAGE} || exit 0"
        }

        success {
            echo "✅ Pipeline executed successfully!"
        }

        failure {
            echo "❌ Pipeline failed. Please check the logs for errors."
        }
    }
}
