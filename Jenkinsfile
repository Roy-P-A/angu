pipeline {
    agent any

    environment {
        NVM_DIR = "${env.HOME}/.nvm"
        REMOTE_USER = "crossroads"
        REMOTE_HOST = "97.74.95.254"
        REMOTE_DIR = "/var/www/anguman/angu/dist"
        REMOTE_PASSWORD = "Shelby123#"
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Make sure to configure the Git repository URL
                git url: 'https://github.com/Roy-P-A/angu.git', branch: 'main'
            }
        }

        stage('Set Node Version') {
            steps {
                script {
                    sh '''
                        export NVM_DIR="$NVM_DIR"
                        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
                        nvm use 18.19.0
                    '''
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    export NVM_DIR="$NVM_DIR"
                    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
                    nvm use 18.19.0
                    npm install
                '''
            }
        }

        stage('Build Angular Project') {
            steps {
                sh '''
                    export NVM_DIR="$NVM_DIR"
                    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
                    nvm use 18.19.0
                    ng build
                '''
            }
        }

        stage('Transfer Build to Remote Server') {
            steps {
                sh '''
                    # Ensure .ssh directory and known_hosts file
                    mkdir -p ~/.ssh
                    touch ~/.ssh/known_hosts

                    # Add remote host key to known_hosts
                    ssh-keyscan -H $REMOTE_HOST >> ~/.ssh/known_hosts

                    # Transfer the dist folder using sshpass
                    sshpass -p "$REMOTE_PASSWORD" scp -r dist/* $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
