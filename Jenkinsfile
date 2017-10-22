pipeline {
    agent {
        docker { 
            image 'icrosby/jenkins-agent:dind'
            args '-u 10000:10000'
        }
    }

    stages {
        stage('Build') {
            environment {
                GOPATH = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"
            }
            steps {
                echo 'Building...'
                sh 'go build'
                
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'go test'
            }
        }
        stage('BuildImage') {
            steps {
                echo 'Building Docker image'
                sh 'sudo docker build -t ${JOB_NAME}:${BUILD_ID} .'
            }
        }
    }
}
