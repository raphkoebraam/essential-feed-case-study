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
        // generate report
        sh 'bundle exec slather coverage --html --scheme CI EssentialFeed/EssentialFeed.xcodeproj'

        // publish html
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
