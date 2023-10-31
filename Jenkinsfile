/* Requires the Docker Pipeline plugin */

/*
pipeline {
    agent { docker { image 'ruby:3.2.2-alpine3.18' } }
    stages {
        stage('build') {
            steps {
                sh 'bundle install && rails s'
            }
        }
    }
}
*/

pipeline {
    agent any
    stages {
        stage('verify tooling') {
            sh '''
                docker --version
                docker-compose --version
                docker info
                curl --version
                jq --version
            '''
        }
    }
}