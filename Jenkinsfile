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
          ansiColor('xterm') {
            sh "terraform init"
            try {
              sh "terraform workspace select $ENV"
            } catch (err) {
              sh "terraform workspace new $ENV"
            }
          }
        }
      }
  
    if (params.ACTION == 'BUILD') {
        if (!params.CONFIRM) {
          stage('Build Plan') {
            ansiColor('xterm') {
              sh """
                cd $LAYER
                terraform plan
              """
            }
          }
        } else {
          stage('Build Apply') {
            ansiColor('xterm') {
              sh """
                cd $LAYER
                echo "yes" | terraform apply
              """
            }
          }
        }
    }
  
    if (params.ACTION == 'DELETE') {
        if (!params.CONFIRM) {
          stage('Delete Plan') {
            ansiColor('xterm') {
              sh """
                cd $LAYER
                terraform plan -destroy
              """
            }
          }
        } else {
          stage('Delete Apply') {
            ansiColor('xterm') {
              sh """
                cd $LAYER
                echo "yes" | terraform destroy
              """
            }
          }
        }
    }
}
