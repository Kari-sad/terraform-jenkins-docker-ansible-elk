pipeline {
		agent any
		stages {
			stage('checkout SCM '){
				steps {
					checkout scm
				}
			}	
			stage('Deploy to kubernetes'){
				steps{
					ansiblePlaybook credentialsId: 'Ansible_ssh', disableHostKeyChecking: true, installation: 'Ansible', playbook: 'playbook.yaml'
				}
			}
		}
	}

