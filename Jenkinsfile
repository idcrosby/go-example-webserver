pipeline {
    agent {
        docker { 
            image 'icrosby/jenkins-agent:kube'
            args '-u root'
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
                sh 'sudo docker build -t ${JOB_NAME} .'
            }
        }
        stage('TestImage') {
            steps {
                echo 'Testing Docker image'
                sh 'sudo docker run ${JOB_NAME} /test.sh'
            }
        }
    }
}
