node {
    properties([
      parameters([
        choice(choices: ['DEV, QA, PROD'], name: 'ENV'), 
        choice(choices: ['Networking, Autoscaling, Database'], name: 'LAYER'), 
        choice(choices: ['BUILD, DELETE'], name: 'ACTION'), 
        booleanParam('CONFIRM')
      ])
    ])

    stage('Initialization') {
      //cleanWs()
      sh 'terraform init'
      sh "terraform workspace new $ENV"
    }
  
    if (params.ACTION == 'BUILD') {
        if (!params.CONFIRM) {
          stage('Build Plan') {
            sh 'terraform plan'
          }
        } else {
          stage('Build Apply') {
            sh 'echo "yes" | terraform apply'
          }
        }
    }
  
    if (params.ACTION == 'DELETE') {
        if (!params.CONFIRM) {
          stage('Delete Plan') {
            sh 'echo "no" | terraform destroy'
          }
        } else {
          stage('Delete Apply') {
            sh 'echo "yes" | terraform destroy'
          }
        }
    }
}
