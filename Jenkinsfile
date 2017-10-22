pipeline {
    agent {
        docker { 
            image 'icrosby/jenkins-agent:dind'
            args '-u 10000:10000'
        }
    }

    stages {
        stage('BuildImage') {
            steps {
                echo 'Building Docker image'
                sh 'sudo docker build -t ${JOB_NAME}:${BUILD_ID} .'
            }
        }
    }
}
