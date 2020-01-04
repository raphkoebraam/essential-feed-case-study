pipeline {
  agent any
  stages {
      stage('Prepare Environment') {
        steps {
          // Makes Jenkins aware of rbenv
          sh '''
          echo $HOME
          RBENV_HOME=/usr/local/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims
          echo $RBENV_HOME
          [[ ":$PATH:" != *":$RBENV_HOME:"* ]] && PATH="${RBENV_HOME}:${PATH}"
          echo $PATH
          '''
          
          // Sets ruby version
          sh 'rbenv local `cat .ruby-version`'

          // Installs bundler
          sh 'gem install bundler'

          // Install gems
          sh 'bundle install'
      }
    }

    stage('Build & Test') {
      steps {
        sh 'xcodebuild clean build test -project EssentialFeed/EssentialFeed.xcodeproj -scheme "CI" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO'
      }
    }

    stage('Slather Report') {
      steps {
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
