node {

    def DOCKER_HUB_ACCOUNT = 'vlal'
    def DOCKER_IMAGE_NAME = 'go-example-webserver'
    def K8S_DEPLOYMENT_NAME = 'go-example-webserver'

    checkout scm

    stage("build")
    echo 'Building Go App'
    docker.image('icrosby/jenkins-agent:kube').withRun('-u root').inside{
        sh 'go build' 
    }

    stage("test")
    echo 'Testing Go App'
    docker.image('icrosby/jenkins-agent:kube').withRun('-u root').inside{
        sh 'go test' 
    }

    stage("build image")
    echo 'Building Docker image'
    def app = docker.build "${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${BUILD_ID}"

    echo 'Testing Docker image'
    stage("test image") {
        docker.image("${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${BUILD_ID}").inside {
            sh './test.sh'
        }
    }

    stage("Push")
    echo 'Pushing Docker Image'
    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
        app.push()
    }
}