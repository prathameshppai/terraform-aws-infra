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
      terraform init
      terraform workspace new $ENV
    }
  
  if (params.ACTION == 'BUILD') {
    if (!params.CONFIRM) {
      stage('Build Plan') {
        terraform plan
      }
    } else {
      stage('Build Apply') {
        echo "yes" | terraform apply
      }
    }
  }
  
  if (params.ACTION == 'DELETE') {
    if (!params.CONFIRM) {
      stage('Delete Plan') {
        echo "no" | terraform destroy
      }
    } else {
      stage('Delete Apply') {
        echo "yes" | terraform destroy
      }
    }
  }
}
