pipeline {
    agent {
        label 'node1-build'
    }

    environment {
        AWS_REGION = 'ap-south-1' // Change this to your AWS region
        ECR_REPO_1 = '123456789012.dkr.ecr.ap-south-1.amazonaws.com/pa-start' // Your first ECR repo
        ECR_REPO_2 = '123456789012.dkr.ecr.ap-south-1.amazonaws.com/pa-middle' // Your second ECR repo
        ECR_REPO_3 = '123456789012.dkr.ecr.ap-south-1.amazonaws.com/pa-end' // Your third ECR repo
        DOCKER_IMAGE_1 = "${ECR_REPO_1}:${BUILD_NUMBER}"
        DOCKER_IMAGE_2 = "${ECR_REPO_2}:${BUILD_NUMBER}"
        DOCKER_IMAGE_3 = "${ECR_REPO_3}:${BUILD_NUMBER}"
        SONAR_URL = "http://50.19.144.223:9000"
        GIT_REPO_NAME = "Jenkins-end-to-end"
        GIT_USER_NAME = "vijayrajuyj1"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out the code...'
                sh 'echo passed'
            }
        }

        stage('Build and Test') {
            steps {
                echo 'Building and testing the project...'
                sh 'ls -ltr'
                sh 'cd spring-boot-app && mvn clean package'
            }
        }

        stage('Static Code Analysis') {
            steps {
                echo 'Performing static code analysis with SonarQube...'
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh 'cd spring-boot-app && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
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
