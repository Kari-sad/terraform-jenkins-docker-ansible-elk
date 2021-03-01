pipeline {
		agent any
		environment {
            /* repository in Dockerhub */        
			DOCKER_HUB_REPO = "karinegh18/flask-app"
			/* this should be configured in jenkins manage credentials */
			REGISTRY_CREDENTIAL = "dockerhub"	
		}
		stages {
			stage('checkout SCM '){
				steps {
					checkout scm
				}
			}	
			stage('Building new image ') {
				steps {
					script {
						dir('./flask_app') {
							sh 'docker image build -t $DOCKER_HUB_REPO:latest .'
							sh 'docker image tag $DOCKER_HUB_REPO:latest $DOCKER_HUB_REPO:$BUILD_NUMBER'
							echo "image buit successfuly"
						}	
					}
				}	
			}
			stage('Pushing image to dockerhub'){
				steps {
					script {
						docker.withRegistry( '', REGISTRY_CREDENTIAL ) {
							sh 'docker push $DOCKER_HUB_REPO:$BUILD_NUMBER'
							sh 'docker push $DOCKER_HUB_REPO:latest'
						}
						
						echo "Image pushed to repository"
					}
				}
			}
			stage('Deploy to kubernetes using ansible'){
					steps{
  						ansiblePlaybook credentialsId: 'Ansible_ssh', disableHostKeyChecking: true, installation: 'Ansible', playbook: 'playbook.yaml'
					}
				}
		}
	}

