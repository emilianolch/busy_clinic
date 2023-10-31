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
            steps {
                sh '''
                    docker --version
                    docker compose --version
                    docker info
                '''
            }
        }
        stage('build') {
            steps {
                sh 'docker compose build'
            }
        }
        // stage('test') {
        //     steps {
        //         sh 'docker compose run --rm app bundle exec rspec'
        //     }
        // }
        stage('deploy') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }
}