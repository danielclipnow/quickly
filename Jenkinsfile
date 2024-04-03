pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    git credentialsId: '83759a99-5eb1-4406-8296-e9e4e3bf0594', url: 'git@github.com:danielclipnow/quickly.git'
                }
            }
        }
        stage('Update with Upstream') {
            steps {
                sshagent(['83759a99-5eb1-4406-8296-e9e4e3bf0594']) {
                    sh 'git remote add upstream https://github.com/fgengine/quickly.git'
                    sh 'git fetch upstream'
                    sh 'git merge upstream/master'
                    sh 'git push origin HEAD:master'
                }
            }
        }
    }
    post {
        always {
             script {
                if (getContext(hudson.FilePath)) {
                    deleteDir()
                }
            }
            dir("${env.WORKSPACE}@tmp") {
                deleteDir()
            }
            dir("${env.WORKSPACE}@script") {
                deleteDir()
            }
            dir("${env.WORKSPACE}@script@tmp") {
                deleteDir()
            }
        }
    }
}