node {
    properties([
      parameters([
        choice(choices: ['DEV', 'QA', 'PROD'], name: 'ENV'), 
        choice(choices: ['Networking', 'Autoscaling', 'Database'], name: 'LAYER'), 
        choice(choices: ['BUILD', 'DELETE'], name: 'ACTION'), 
        booleanParam('CONFIRM')
      ])
    ])

    stage('Git checkout') {
          cleanWs()
          git url: 'https://github.com/prathameshppai/terraform-aws-infra.git', branch: 'main'
      }

    stage('Initialization') {
        dir(params.LAYER) {
          sh "terraform init"
          try {
            sh "terraform workspace select $ENV"
          } catch (err) {
            echo "Caught: ${err}"
            throw ${err}
          }           
        }
      }
  
    if (params.ACTION == 'BUILD') {
        if (!params.CONFIRM) {
          stage('Build Plan') {
            sh """
              cd $LAYER
              terraform plan
            """
          }
        } else {
          stage('Build Apply') {
            sh """
              cd $LAYER
              echo "yes" | terraform apply
            """
          }
        }
    }
  
    if (params.ACTION == 'DELETE') {
        if (!params.CONFIRM) {
          stage('Delete Plan') {
            sh """
              cd $LAYER
              terraform plan -destroy
            """
          }
        } else {
          stage('Delete Apply') {
            sh """
              cd $LAYER
              echo "yes" | terraform destroy
            """
          }
        }
    }
}
