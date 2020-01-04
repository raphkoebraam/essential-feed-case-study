pipeline {
    agent any
    stages {
        stage('Build & Test') {
            steps {
                sh 'xcodebuild clean build test -project EssentialFeed/EssentialFeed.xcodeproj -scheme "CI" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO'
            }
        }

        stage('Slather Report') {
            steps {
                sh '''
                    RBENV_HOME=/usr/local/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims
                    [[ ":$PATH:" != *":$RBENV_HOME:"* ]] && PATH="${RBENV_HOME}:${PATH}"

                    eval "$(rbenv init -)"

                    rbenv local `cat .ruby-version`

                    gem install bundler

                    bundle install

                    # Generates the report
                    bundle exec slather coverage --html --scheme CI EssentialFeed/EssentialFeed.xcodeproj
                '''

                // Publishes html
                publishHTML target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: false,
                        keepAll: true,
                        reportDir: 'test-reports/slater/',
                        reportFiles: 'index.html',
                        reportName: 'Code Coverage Report'
                    ]
            }
        }
    }
}
