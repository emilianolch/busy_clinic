/* Requires the Docker Pipeline plugin */
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
