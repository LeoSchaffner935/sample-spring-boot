pipeline {
    agent any
        environment {
        //ENV_DOCKER = credentials('DockerHub')
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
            docker { image 'sonarsource/sonar-scanner-cli:latest' }
        }
            steps {
                script {
                    sh 'echo scanning!'
                    scannerHome = tool 'MySonar';
                    withSonarQubeEnv('MySonarQube') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
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
                    docker.withRegistry('https://registry.hub.docker.com/', 'DockerHub') {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Deploy App') {
            steps {
                sh 'echo deploy to kubernetes'
                /*withKubeConfig(caCertificate: '', clusterName: "$EKS_CLUSTER_NAME", contextName: 'arn:aws:eks:us-east-1:855430746673:cluster/sre-lab', credentialsId: 'K8S', namespace: 'leo-schaffner', serverUrl: 'https://8175C01E797F39C77ED8AB94CD24986B.gr7.us-east-1.eks.amazonaws.com') {
                    sh ('kubectl apply -f /home/ubuntu/kubernetes.yml')
                }*/
            }
        }
    }
}
