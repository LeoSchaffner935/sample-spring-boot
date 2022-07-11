pipeline {
    agent none
        environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "leoschaffner935/coglab"
        EKS_CLUSTER_NAME = "sre-lab"
    }
    stages {
        stage('build') {
            agent {
                docker {
                    registryUrl 'https://docker.io'
                    image 'openjdk:11-jdk' }
            }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
            }
        }
        /*stage('sonarqube') {
        agent {
            docker { image 'sonar-scanner-cli:latest' }
        }
            steps {
                sh 'echo scanning!'
            }
        }*/
        stage('docker build') {
            agent any
            steps {
                script {
                    sh 'echo docker build'
                    dockerImage = docker.build("$DOCKERIMAGE:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('docker push') {
            agent any
            steps {
                script {
                    sh 'echo docker push!'
                    docker.withRegistry('https://registry.hub.docker.com/','$ENV_DOCKER') {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Deploy App') {
            agent any
            steps {
                sh 'echo deploy to kubernetes'
                withKubeConfig(caCertificate: '', clusterName: "$EKS_CLUSTER_NAME", contextName: 'arn:aws:eks:us-east-1:855430746673:cluster/sre-lab', credentialsId: 'K8S', namespace: 'leo-schaffner', serverUrl: 'https://8175C01E797F39C77ED8AB94CD24986B.gr7.us-east-1.eks.amazonaws.com') {
                    sh ('kubectl apply -f /home/ubuntu/kubernetes.yml')
                }
            }
        }
    }
}
