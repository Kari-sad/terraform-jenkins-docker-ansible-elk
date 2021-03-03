
## Environement: ##

- 1 VM machine with ubuntu 20.04   
### Required software installation ###
### 1- Install Java   ###
    sudo apt update && sudo apt upgrade 
    sudo apt-get install openjdk-8-jdk

**Check java version installed**  

    java -version

**Set JAVA_HOME:**  
 
- Edit .bashrc and add these lines at the end

        export JAVA_HOME=/usr
        export PATH=$JAVA_HOME/bin:$PATH

### 2- Install Jenkins 
 
[https://pkg.jenkins.io/debian-stable/](https://pkg.jenkins.io/debian-stable/)

    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -  

- Add the following entry in your /etc/apt/sources.list:
    
  `deb https://pkg.jenkins.io/debian-stable binary/ ` 
  `echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list`

- Update local package index, then finally install Jenkins: 
 
	    sudo apt-get update  
	    sudo apt-get install jenkins  

**Start Jenkins**  

- You can start the Jenkins service with the command:  
 
 `sudo systemctl start jenkins`  
 
- You can enable the Jenkins service at boot with the command:  
 
 `sudo systemctl enable jenkins`    
 
- You can check the status of the Jenkins service using the command:  
 
   `sudo systemctl status jenkins ` 


**Accessing Jenkins**  

- By default jenkins runs at port 8080, You can access jenkins at

    *http://YOUR-SERVER-PUBLIC-IP:8080*
 
- Unlock Jenkins page will be shown.
 
     `cat /var/lib/jenkins/secrets/initialAdminPassword`
- Copy the key and paste it into unlock jenkins /administrator password     
- **Install suggested plugins** (if not you need to be aware of needed plugins  and install them one by one)   
- create new admin user    
- save and finish    
- start jenkins  

### 3- install git ###

    sudo apt update  
    sudo apt install git  


Then set the path to git installer (**/usr/bin/git**) in jenkins Global Tool Configuration   
  
**Configure identity if needed**
   
    git config --global user.name "abc de"   
    git config --global user.email abcde@example.com

### 4- Install docker ###
[Follow link](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)


> **ERROR:** dial unix /var/run/docker.sock: connect: permission denied  
> **FIX:**  [https://www.digitalocean.com/community/questions/how-to-fix-docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket](https://www.digitalocean.com/community/questions/how-to-fix-docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket)
  
    sudo usermod -aG docker ${USER}  
    sudo usermod -aG docker jenkins  
    systemctl restart docker  
    sudo chmod 666 /var/run/docker.sock ---this worked

### 5- Install terraform ###

[link to official installation website](https://learn.hashicorp.com/tutorials/terraform/install-cli)  

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -  
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"  
    sudo apt-get update && sudo apt-get install terraform

### 6- Install ansible ###
 
    sudo apt-add-repository ppa:ansible/ansible  
    sudo apt update  
    sudo apt install ansible  

once installation complete, edit `/etc/ansible/hosts` and add    
 
    [all:vars]  
    ansible_python_interpreter=/usr/bin/python3

### 7- Docker compose ###

follow installion procedure in this link [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

### 8- In Jenkins, add these plugins ###
 
- Docker Pipeline  
- Ansible ( in plugin configuration, specify path as /etc/bin/)
 

## Provision a local cluster using terraform ##
We will be using terraform to provision a KIND (Kubernetes IN Docker) cluster into our VM.  
**Used provider:** [https://registry.terraform.io/providers/kyma-incubator/kind/latest/docs](https://registry.terraform.io/providers/kyma-incubator/kind/latest/docs)

**Procedure**

    cd terraform  
    terraform init  
    terraform plan 
    terraform apply

##  Jenkins pipeline   ##

create a jenkins pipeline using the jenkinsfile in this repository.  
**Jenkins pipeline stages:**  

1. Pull the git repository
1. Build an image foe the included flask app  
1. Push the created image to dockerhub  
1. Play an ansible playbook (playbook.yaml) that will apply kubernetes.yaml. This later will deploy 3 replicats of the flask app to a kubernetes cluster and run a service.  
 

## Monitoring using ELK Stack  ##


I used the dockerized ELK stack installation from [https://github.com/deviantony/docker-elk](https://github.com/deviantony/docker-elk)

**procedure**  



- Clone the repository  
- `cd docker-elk`  
- `docker-compose up -d`
- Check the elk docker containers are up and running by executing `docker ps`  

**Used metrics**  

- System metric: to monitor my VM local system metrics like CPU/memory/disk usage and network utilization 

- Docker metric: to monitor docker containers present in our vm and also the kubernetes control plane. Default metricsets are cpu, diskio, healthcheck, info, memory, and network.
 
- kubernetes metric:to monitor kubernetes cluster nodes,pods , containers ...---> didn't get it to work