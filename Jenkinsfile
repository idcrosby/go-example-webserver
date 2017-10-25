def appName="go-webserver"
def project=""
def tag="blue"
def altTag="green"

node {
  project = env.PROJECT_NAME
  stage("Initialize") {
    echo "Initializing..."
    sh "kubectl get ing ingress-blue-green -o jsonpath='{.spec.rules[2].http.paths[0].backend.serviceName}' > activeservice"
    activeService = readFile('activeservice').trim()
    if (activeService == "${appName}-blue") {
      tag = "green"
      altTag = "blue"
    }

    sh "kubectl get ing ingress-blue-green -o jsonpath='{.spec.rules[2].host}' > deploy_route"
    deploy_route = readFile('deploy_route').trim()
  }

  stage("Build") {
    echo "Building tag ${tag}..."
    docker.build appName:${tag}
  }

  stage("Push") {
    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
      stage("Push")
      echo 'Pushing Docker Image'
      app.push()
    }
  }

  stage("Deploy Test") {
    echo "Deploying test..."
    sh "kubectl set image deployment ${appName}-${tag} go-example-webserver=appName:${tag}"
  }

  stage("Test") {
    input message: "Test new deployment via: http://${deploy_route}. Approve?", id: "approval"
  }

  stage("Go Live") {
    sh "kubectl patch ing ingress-blue-green -p '{"spec":{"rules":[{"host": "go-webserver.com","http":{"paths":[{"backend":{"serviceName":"go-webserver-${tag}","servicePort":80}}]}},{"host": "blue-go-webserver.com","http":{"paths":[{"backend":{"serviceName":"go-webserver-blue","servicePort":80}}]}},{"host": "green-go-webserver.com","http":{"paths":[{"backend":{"serviceName":"go-webserver-green","servicePort":80}}]}}]}}'"
  }