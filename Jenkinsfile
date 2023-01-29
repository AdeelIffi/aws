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
                whoami
                sh 'aws s3 ls'
            }
        }
    }
}
