pipeline {
    agent {
        docker{
            image 'selenium/standalone-chrome:latest'
        }
    }

triggers {
    cron('0 3 * * *')
}

stages {
    stage('Pobranie kodu') {
        steps {
            checkout scm
        }
    }

    stage('Instalacja zależności') {
        steps {
            sh 'sudo apt-get update && sudo apt-get install -y python3-pip python3-venv'
                sh 'python3 -m venv venv'
                sh './venv/bin/pip install --no-cache-dir -r requirements.txt'
            }
        }

    stage('Uruchomienie testów Parabanka') {
            steps {
                sh 'mkdir -p results'
                // Uruchomienie testów z użyciem wirtualnego środowiska Pythona
                sh './venv/bin/python -m robot --outputdir results tests/'
            }
        }
    }


post {
        always {
            robot outputPath: 'results/output.xml'
            archiveArtifacts artifacts: 'results/*.html', fingerprint: true
        }
    }       
}