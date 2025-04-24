pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'pankajkumar05/petclinic'
        CONTAINER_NAME = 'petclinic-demo'
        LOCAL_PORT = '3001'
        APP_PORT = '8080' 
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout from GitHub repository') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/aajay30/spring-petclinic.git']]
                )
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:latest
                        docker logout
                    """
                }
            }
        }

        stage('Run Container Locally (Port 3001)') {
            steps {
                script {
                    // Clean up previous container (if any)
                    sh """
                        docker rm -f ${CONTAINER_NAME} || true
                        docker pull ${DOCKER_IMAGE}:latest
                        docker run -d --name ${CONTAINER_NAME} -p ${LOCAL_PORT}:${APP_PORT} ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
    }

    post {
        always {
            echo '✅ CI/CD pipeline run complete.'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
