pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        BACKEND_IMAGE = "yourdockerhub/student-backend:${BUILD_NUMBER}"
        FRONTEND_IMAGE = "yourdockerhub/student-frontend:${BUILD_NUMBER}"
    }
    stages {
        stage('Build Backend') {
            steps {
                dir('student-backend') {
                    sh './mvnw clean package -DskipTests'
                }
            }
        }
        stage('Build Frontend') {
            steps {
                dir('student-frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }
        stage('Build Docker Images') {
            steps {
                sh 'docker-compose build'
            }
        }
        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        sh "docker tag student-manager_backend ${BACKEND_IMAGE}"
                        sh "docker tag student-manager_frontend ${FRONTEND_IMAGE}"
                        sh "docker push ${BACKEND_IMAGE}"
                        sh "docker push ${FRONTEND_IMAGE}"
                    }
                }
            }
        }
        stage('Deploy (Optional)') {
            steps {
                echo 'Triển khai lên server hoặc môi trường production tại đây.'
            }
        }
    }
}
