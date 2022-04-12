node {
    properties([
      parameters([
        choice(choices: ['DEV', 'QA', 'PROD'], name: 'ENV'), 
        choice(choices: ['Networking', 'Autoscaling', 'Database'], name: 'LAYER'), 
        choice(choices: ['BUILD', 'DELETE'], name: 'ACTION'), 
        booleanParam('CONFIRM')
      ])
    ])

    stage('Initialization') {
          sh "cd $LAYER"
          sh 'terraform init'
          sh "terraform workspace new $ENV || true"
      }
  
    if (params.ACTION == 'BUILD') {
        if (!params.CONFIRM) {
          stage('Build Plan') {
            sh "cd $LAYER"
            sh 'terraform plan'
          }
        } else {
          stage('Build Apply') {
            sh "cd $LAYER"
            sh 'echo "yes" | terraform apply'
          }
        }
    }
  
    if (params.ACTION == 'DELETE') {
        if (!params.CONFIRM) {
          stage('Delete Plan') {
            sh "cd $LAYER"
            sh 'echo "no" | terraform destroy'
          }
        } else {
          stage('Delete Apply') {
            sh "cd $LAYER"
            sh 'echo "yes" | terraform destroy'
          }
        }
    }
}
