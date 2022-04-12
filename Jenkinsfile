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
        sh """
          cd $LAYER
          terraform init
          terraform workspace new $ENV || true
        """
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
