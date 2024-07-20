pipeline {
    agent any

    environment {
        NVM_DIR = "${HOME}/.nvm"
        REMOTE_USER = "crossroads"
        REMOTE_HOST = "97.74.95.254"
        REMOTE_DIR = "/var/www/anguman/angu/dist"
        REMOTE_PASSWORD = "Shelby123#"  // Store this securely!
    }

    stages {
        stage('Set up NVM') {
            steps {
                script {
                    sh '''
                        mkdir -p $NVM_DIR
                        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                        nvm use 18.19.0
                    '''
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    sh '''
                        npm install
                    '''
                }
            }
        }
        stage('Build Project') {
            steps {
                script {
                    sh '''
                        mkdir -p $NVM_DIR
                        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                        nvm use 18.19.0
                        ng build
                    '''
                }
            }
        }
        stage('Transfer Build to Remote Server') {
            steps {
                script {
                    sh '''
                        mkdir -p ~/.ssh
                        touch ~/.ssh/known_hosts
                        ssh-keyscan -H $REMOTE_HOST >> ~/.ssh/known_hosts
                        sshpass -p "$REMOTE_PASSWORD" scp -r dist/* $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
                    '''
                }
            }
        }
    }
}

