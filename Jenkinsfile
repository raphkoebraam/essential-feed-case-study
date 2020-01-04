pipeline {
    agent any
    stages {
        stage('Build & Test') {
            steps {
                sh './scripts/setup_environment.sh'
                sh 'xcodebuild clean build test -project EssentialFeed/EssentialFeed.xcodeproj -scheme "CI" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO'
            }
        }

        stage('Slather Report') {
            steps {
                sh './scripts/setup_environment.sh'

                // Generates report
                sh 'bundle exec slather coverage --html --scheme CI EssentialFeed/EssentialFeed.xcodeproj'

                // Publishes html
                publishHTML target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: false,
                        keepAll: true,
                        reportDir: 'test-coverage/slater',
                        reportFiles: 'index.html',
                        reportName: 'Code Coverage Report'
                    ]
            }
        }
    }
}
