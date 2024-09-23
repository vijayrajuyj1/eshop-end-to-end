pipeline {
    agent {
        label 'eshop'
    }

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO_1 = '992382774897.dkr.ecr.us-east-1.amazonaws.com/frontend'
        ECR_REPO_2 = '992382774897.dkr.ecr.us-east-1.amazonaws.com/backend'
        ECR_REPO_3 = '992382774897.dkr.ecr.us-east-1.amazonaws.com/socket'
        DOCKER_IMAGE_1 = "${ECR_REPO_1}:${BUILD_NUMBER}"
        DOCKER_IMAGE_2 = "${ECR_REPO_2}:${BUILD_NUMBER}"
        DOCKER_IMAGE_3 = "${ECR_REPO_3}:${BUILD_NUMBER}"
        SONAR_URL = "http://54.82.44.149:9000"
        GIT_REPO_NAME = "eshop-end-to-end"
        GIT_USER_NAME = "vijayrajuyj1"
    }

    stages {
        stage('Install Node.js') {
            steps {
                echo 'Installing Node.js...'
                sh '''
                    # Install Node.js and npm
                    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
                    sudo apt-get install -y nodejs
                    npm install -g yarn 
                '''
            }
        }

        stage('Install Dependencies and Test') {
            steps {
                echo 'Installing Node.js dependencies and running tests...'
                sh 'cd frontend && npm install --legacy-peer-deps'
                sh 'cd backend && npm install --legacy-peer-deps'
                sh 'cd socket && npm install --legacy-peer-deps'
            }
        }

        stage('Static Code Analysis for frontend') {
            steps {
                echo 'Performing static code analysis with SonarQube...'
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh '''
                      cd frontend && npx sonar-scanner \
                      -Dsonar.projectKey=frontend \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=${SONAR_URL} \
                      -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }

        stage('Static Code Analysis for backend') {
            steps {
                echo 'Performing static code analysis with SonarQube...'
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh '''
                      cd backend && npx sonar-scanner \
                      -Dsonar.projectKey=backend \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=${SONAR_URL} \
                      -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }

        stage('Static Code Analysis for socket') {
            steps {
                echo 'Performing static code analysis with SonarQube...'
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh '''
                      cd socket && npx sonar-scanner \
                      -Dsonar.projectKey=socket \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=${SONAR_URL} \
                      -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }

        stage('Login to ECR') {
            steps {
                echo "Logging into Amazon ECR..."
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']]) {
                    sh '''
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REPO_1}
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REPO_2}
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REPO_3}
                    '''
                }
            }
        }

        stage('Build and Push Docker Images') {
            steps {
                script {
                    echo "Building Docker images..."
                    sh 'cd frontend && docker build -t ${DOCKER_IMAGE_1}  .' // Frontend Dockerfile
                    sh 'cd backend && docker build -t ${DOCKER_IMAGE_2}  .'  // Backend Dockerfile
                    sh 'cd socket && docker build -t ${DOCKER_IMAGE_3}  .'   // Socket Dockerfile

                    echo "Pushing Docker images to Amazon ECR..."
                    sh '''
                        docker push ${DOCKER_IMAGE_1}
                        docker push ${DOCKER_IMAGE_2}
                        docker push ${DOCKER_IMAGE_3}
                    '''
                }
            }
        }

        stage('Update Deployment File') {
            steps {
                echo 'Updating the Kubernetes deployment file with the new image tag...'
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        git config user.email "vijayarajuyj1@gmail.com"
                        git config user.name "vijayrajuyj1"
                        sed -i "s/{{ .Values.image.tag }}/${BUILD_NUMBER}/g" k8s/deployment.yaml
                        git add k8s/deployment.yml
                        git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                    '''
                }
            }
        }
    }
}
