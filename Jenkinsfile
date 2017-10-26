node {

    def DOCKER_HUB_ACCOUNT = 'icrosby'
    def DOCKER_IMAGE_NAME = 'go-example-webserver'
    def DOCKER_REGISTRY = 'localhost:5000'
    def K8S_DEPLOYMENT_NAME = 'go-example-webserver'

    checkout scm

    echo 'Building Go App'
    stage("build") {
        docker.image("icrosby/jenkins-agent:kube").inside('-u root') {
            sh 'go build' 
        }
    }

    echo 'Testing Go App'
    stage("test") {
        docker.image('icrosby/jenkins-agent:kube').inside('-u root') {
            sh 'go test' 
        }
    }

    echo 'Building Docker image'
    stage('BuildImage') 
    def app = docker.build("${DOCKER_REGISTRY}/${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}", '.')

    echo 'Testing Docker image'
    stage("test image") {
        docker.image("${DOCKER_REGISTRY}/${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}").inside {
            sh './test.sh'
        }
    }

    stage("Push")
    echo 'Pushing Docker Image'
    docker.withRegistry('http://localhost:5000/') {
        app.push()
    }

    stage("Deploy") 
    echo "Deploying image"
    docker.image('smesch/kubectl').inside{
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
            sh "kubectl --kubeconfig=$KUBECONFIG set image deployment/${K8S_DEPLOYMENT_NAME} ${K8S_DEPLOYMENT_NAME}=${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}"
        }
    }
}
