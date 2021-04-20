pipeline {
    agent any
    triggers {
        githubPush()
    }
    stages {
        stage('DeployEFK') {
            steps {
                echo 'Deploying the EFK...'
                build job: 'DeployEFK'
            }
        }
        stage('DeployMetrics') {
            steps {
                echo 'Deploying the Metrics...'
                build job: 'DeployWebapp'
            }
        }
        stage('DeployWebapp') {
            steps {
                echo 'Deploying the Webapp...'
                build job: 'DeployWebapp'
            }
        }
        stage('DeployProcessorWebapp') {
            steps {
                echo 'Deploying the ProcessorWebapp...'
                build job: 'DeployWebapp'
            }
        }
        stage('DeployNotifierWebapp') {
            steps {
                echo 'Deploying the NotifierWebapp...'
                build job: 'DeployWebapp'
            }
        }
    }
}
