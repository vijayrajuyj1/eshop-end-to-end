pipeline {
    agent {
        label 'eshop'
    }

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO_1 = '992382774897.dkr.ecr.us-east-1.amazonaws.com/frontend1'
        ECR_REPO_2 = '992382774897.dkr.ecr.us-east-1.amazonaws.com/frontend2'
        ECR_REPO_3 = '992382774897.dkr.ecr.us-east-1.amazonaws.com/socket'
        ECR_REPO_BACKEND = '992382774897.dkr.ecr.us-east-1.amazonaws.com/backend'
        SONAR_URL = "http://54.82.44.149:9000"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out the code...'
                sh 'git clone https://github.com/vijayrajuyj1/eshop-end-to-end.git eshop'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing project dependencies...'
                dir('eshop/frontend1') { sh 'yarn install' }
                dir('eshop/frontend2') { sh 'yarn install' }
                dir('eshop/backend') { sh 'npm install' }
                dir('eshop/socket') { sh 'yarn install' }
            }
        }

        stage('Static Code Analysis for Frontend') {
            steps {
                echo 'Performing static code analysis for Frontend 1...'
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    dir('eshop/frontend1') {
                        sh '''
                            npm run sonar:sonar -- -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}
                        '''
                    }
                }
            }
        }

        stage('Static Code Analysis for Backend') {
            steps {
                echo 'Performing static code analysis for Frontend 2...'
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    dir('eshop/backend') {
                        sh '''
                            npm run sonar:sonar -- -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}
                        '''
                    }
                }
            }
        }

        stage('Static Code Analysis for Socket') {
            steps {
                echo 'Performing static code analysis for Backend...'
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    dir('eshop/socket') {
                        sh '''
                            npm run sonar:sonar -- -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}
                        '''
                    }
                }
            }
        }
        // Add other stages for building, pushing Docker images, etc.
    
 
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
                    sh 'cd spring-boot-app && docker build -t ${DOCKER_IMAGE_1} .'
                    sh 'cd spring-boot-app && docker build -t ${DOCKER_IMAGE_2} .'
                    sh 'cd spring-boot-app && docker build -t ${DOCKER_IMAGE_3} .'

                    echo "Pushing Docker images to Amazon ECR..."
                    sh '''
                        docker push ${DOCKER_IMAGE_1}
                        docker push ${DOCKER_IMAGE_2}
                        docker push ${DOCKER_IMAGE_3}
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    try {
                        echo "Running Docker containers..."
                        def container1 = docker.image("${DOCKER_IMAGE_1}").run("-d -p 8082:8082")
                        def container2 = docker.image("${DOCKER_IMAGE_2}").run("-d -p 8083:8083")
                        def container3 = docker.image("${DOCKER_IMAGE_3}").run("-d -p 8084:8084")
                        echo "Running containers: ${container1.id}, ${container2.id}, ${container3.id}"
                    } catch (Exception e) {
                        echo "Failed to run Docker containers: ${e.message}"
                        throw e
                    }
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
                        sed -i "s/{{ .Values.image.tag }}/${BUILD_NUMBER}/g" spring-boot-app-manifests/deployment.yml
                        git add spring-boot-app-manifests/deployment.yml
                        git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                    '''
                }
            }
        }
    }
}

