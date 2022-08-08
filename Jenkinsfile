pipeline {
    agent none
    environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "coglab"
        EKS_CLUSTER_NAME = "cog-cluster"
    }
    stages {
        stage('build') {
            agent { docker { image 'openjdk:11-jdk' } }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
                // stash includes: 'build/**/*', name: 'build'
            }
        }
        stage('sonarqube') {
            agent { docker { image 'sonarsource/sonar-scanner-cli:latest' } }
            steps {
                sh 'echo scanning!'
                // unstash 'build'
                sh 'sonar-scanner'
            }
        }
        stage('docker build') {
            agent any
            steps {
                sh 'echo docker build!'
                script {
                    dockerImage = docker.build("$ENV_DOCKER_USR/$DOCKERIMAGE")
                }
            }
        }
        stage('docker push') {
            agent any
            steps {
                sh 'echo docker push!'
                script {
                    dockerImage.push("$BUILD_ID")
                    dockerImage.push('latest')
                }
            }
        }
        stage('Deploy App') {
            agent { docker { image 'jshimko/kube-tools-aws:3.8.1'
            // args '-u root --privileged'
            } }
            steps {
                sh 'echo deploy to kubernetes!'
                /*withKubeConfig(clusterName: "$EKS_CLUSTER_NAME", contextName: 'arn:aws:eks:us-east-1:855430746673:cluster/sre-lab', credentialsId: 'k8s', namespace: 'leo-schaffner', serverUrl: 'https://8175C01E797F39C77ED8AB94CD24986B.gr7.us-east-1.eks.amazonaws.com') {
                    sh 'kubectl apply -f kubernetes.yml'
                }*/
                withAWS(credentials: 'aws-credentials') {
                    sh 'aws eks update-kubeconfig --name sre-primer'
                    sh 'chmod +x deployment-status.sh && ./deployment-status.sh'
                    sh "kubectl set image deployment sample-spring-boot -n leo-schaffner springboot-sample=$ENV_DOCKER_USR/$DOCKERIMAGE:$BUILD_ID"
                }
            }
        }
    }
}
