pipeline {
  agent {
    label "node-awsec2-docker"
  }
  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr:"", artifactNumToKeepStr: "5", daysToKeepStr: "", numToKeepStr: "5"))
    disableConcurrentBuilds()
  }
  environment {
    gitcommit = "${gitcommit}"
  }
  tools {
    maven "maven-jenkins"
  }
  stages {
    stage("Build") {
      steps {
        sh "mvn clean package -DskipTests"
      }
    }
    stage("Docker Build & Push") {
      when {
        branch "develop"
      }
      steps {
        script {
          sh "git rev-parse --short HEAD > .git/commit-id"
          gitcommit = readFile(".git/commit-id").trim()

          def app = docker.build("plchavez98/tds-microservice-zuul-server")

          docker.withRegistry("https://registry.hub.docker.com", "docker-hub") {
            app.push("${gitcommit}")
            app.push("latest")
          }
        }
      }
    }
  }
  post {
    success {
      slackSend message: "Build successfully - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
    }
    failure {
      slackSend message: "Build failed - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
    }
  }
}