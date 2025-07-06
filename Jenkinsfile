pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        STACK_NAME = 'todo-list-staging'
    }

    stages {
        stage('Get Code') {
            steps {
                echo 'Descargando código fuente de la rama develop'
                checkout scm
            }
        }

        stage('Static Test') {
            agent { label 'linux-agent1' }
            steps {
                echo 'Ejecutando análisis estático con Flake8 y Bandit'
                sh '''
                pip install flake8 bandit
                flake8 src/ > flake8_report.txt || true
                bandit -r src/ > bandit_report.txt || true
                cat flake8_report.txt
                cat bandit_report.txt
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Construyendo y desplegando con SAM en Staging'
                sh '''
                pip install awscli aws-sam-cli
                sam build
                sam deploy --stack-name $STACK_NAME --region $AWS_REGION --no-confirm-changeset --no-fail-on-empty-changeset --capabilities CAPABILITY_IAM
                '''
            }
        }

        stage('Rest Test') {
            agent { label 'linux-agent1' }
            steps {
                echo 'Ejecutando pruebas de integración'
                script {
                    try {
                        sh '''
                        pip install pytest requests
                        pytest test/integration/todoApiTest.py --maxfail=1 --disable-warnings -q
                        '''
                    } catch (err) {
                        error("Las pruebas de integración fallaron")
                    }
                }
            }
        }

        stage('Promote') {
            steps {
                echo 'Todas las etapas pasaron'
                sshagent(credentials: ['github-ssh']) {
                    sh '''
                    git config --global user.email "tu_correo@ejemplo.com"
                    git config --global user.name "Tu Nombre"
                    git checkout master
                    git merge develop --no-edit
                    git push origin master
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Limpiando workspace'
            cleanWs()
        }
    }
}
