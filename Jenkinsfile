pipeline {
    agent any
        environment {
        ENV_DOCKER = credentials('DockerHub')
        DOCKERIMAGE = "leoschaffner935/coglab"
        EKS_CLUSTER_NAME = "demo-cluster"
        }
    stages {
        stage('build') {
            agent {
                docker { image 'openjdk:11-jdk' }
            }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
            }
        }
        stage('sonarqube') {
        agent {
            docker { image 'sonarsource/sonar-scanner-cli:latest' } }
            steps {
                sh 'echo scanning!'
            }
        }
        stage('docker build') {
            steps {
                script {
                    sh 'echo docker build'
                    dockerImage = docker.build("$DOCKERIMAGE:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('docker push') {
            steps {
                script {
                    sh 'echo docker push!'
                    docker.withRegistry('https://registry.hub.docker.com/',"$ENV_DOCKER") {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Deploy App') {
            steps {
                sh 'echo deploy to kubernetes'               
            }
        }
    }
}
