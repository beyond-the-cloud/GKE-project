pipeline {
    agent any
    triggers {
        githubPush()
    }
    stages {
        stage('DockerHub') {
            steps {
                echo 'Creating the DockerHub...'
                build job: 'DockerHub'
            }
        }
        stage('DeployEFK') {
            steps {
                echo 'Deploying the EFK...'
                build job: 'DeployEFK'
            }
        }
        stage('DeployMetrics') {
            steps {
                echo 'Deploying the Metrics...'
                build job: 'DeployMetrics'
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
                build job: 'DeployProcessorWebapp'
            }
        }
        stage('DeployNotifierWebapp') {
            steps {
                echo 'Deploying the NotifierWebapp...'
                build job: 'DeployNotifierWebapp'
            }
        }
    }
}
