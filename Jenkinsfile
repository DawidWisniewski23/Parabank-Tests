pipeline {
    agent any
    
    stages {
        stage('Instalacja zależności') {
            steps {
                sh 'python3 -m venv venv'
                sh './venv/bin/pip install --no-cache-dir -r requirements.txt'
            }
        }
        
        stage('Uruchomienie testów Parabanka') {
            steps {
                sh 'mkdir -p results'
                sh './venv/bin/python -m robot --outputdir results tests/'
            }
        }
    }
    
post {
        always {
            robot outputPath: 'results'
        }
    }
