node {
    properties([
      parameters([
        choice(choices: ['DEV', 'QA', 'PROD'], name: 'ENV'), 
        choice(choices: ['Networking', 'Autoscaling', 'Database'], name: 'LAYER'), 
        choice(choices: ['BUILD', 'DELETE'], name: 'ACTION'), 
        booleanParam('CONFIRM')
      ])
    ])

    dir("$LAYER") {
        stage('Initialization') {
          //cleanWs()
              sh 'terraform init'
              sh "terraform workspace new $ENV || true"
          }
    }
  
    if (params.ACTION == 'BUILD') {
        if (!params.CONFIRM) {
          stage('Build Plan') {
            dir("$LAYER") {
                sh 'terraform plan'
            }
          }
        } else {
          stage('Build Apply') {
            dir("$LAYER") {
                sh 'echo "yes" | terraform apply'
            }
          }
        }
    }
  
    if (params.ACTION == 'DELETE') {
        if (!params.CONFIRM) {
          stage('Delete Plan') {
            dir("$LAYER") {
                sh 'echo "no" | terraform destroy'
            }
          }
        } else {
          stage('Delete Apply') {
            dir("$LAYER") {
                sh 'echo "yes" | terraform destroy'
            }
          }
        }
    }
}
