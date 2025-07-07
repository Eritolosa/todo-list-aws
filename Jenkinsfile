pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        STACK_NAME = 'todo-list-staging'
    }

    stages {
        stage('Get Code') {
            agent any
            steps {
                echo 'Descargando código fuente de la rama develop'
                checkout scm
            }
        }

        stage('Static Test') {
            agent { label 'linux-agent1' }
            steps {
                echo 'Ejecutando análisis estático con Flake8 y Bandit'
                bat '''
                python -m pip install --upgrade pip
                pip install flake8 bandit
                flake8 src > flake8_report.txt || exit 0
                type flake8_report.txt

                bandit -r src > bandit_report.txt || exit 0
                type bandit_report.txt
                '''
            }
        }

        stage('Deploy') {
            agent { label 'linux-agent1' }
            steps {
                echo 'Despliegue SAM en Staging'
                bat '''
                echo Simulando 'sam build'
                echo Simulando 'sam deploy --stack-name %STACK_NAME% --region %AWS_REGION%'
                '''
            }
        }

        stage('Rest Test') {
            agent { label 'linux-agent1' }
            steps {
                bat 'test_curl.bat'
            }
        }

        stage('Promote') {
            agent { label 'linux-agent1' }
            steps {
                echo 'Merge a master'
                bat '''
                echo git checkout master
                echo git merge develop --no-edit
                echo git push origin master
                '''
            }
        }
    }

     post {
        always {
            echo 'Limpieza de workspace'
            bat '''
            echo Limpieza completada
            '''
        }
    }
}