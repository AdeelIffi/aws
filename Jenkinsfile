pipeline {
    agent any

    stages {
        stage ('First Stage of Build'){
            steps {
                checkout scm
            }
        }

        stage ('Second stage of the build'){
            steps {
                sh 'aws s3 ls'
            }
        }
    }
}
