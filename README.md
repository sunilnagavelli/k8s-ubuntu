
# k8s-installation-ubuntu
<img src=https://user-images.githubusercontent.com/40353788/56882169-7868c100-6a80-11e9-9d9f-be75a3e8ab83.png height=250 width=250>

## About

*This repository is used to create ***Kubernetes Cluster*** using **8** simple steps on ***bare VM's**** 


## Table of Contents

* [What are the pre-requisites ?](#pre-requisites)
* [What are the VM's provisioned ?](#configuration)
* [How to deploy kubernetes cluster ?](#deploy)
* [How to access Kubernetes Dashboard ?](#dashboard)
* [How to install NFS Server ?](#addons)
* [What are the addons provided ?](#addons)


<a id="pre-requisites"></a>
## What are the pre-requisites ?
* [Git](https://git-scm.com/downloads "Git")


<a id="configuration"></a>
## What are the VM's provisioned ?

***Note: We are not going to create any VM's during this process. User is expected to have VM's before proceeding with this repository***

*Below is the ***example configuration*** that we are going to refer ***through out this repository***.*

*Name*|*IP*|*OS*|*RAM*|*CPU*|
|----|----|----|----|----|
*k8smaster*   |*192.168.1.100*|*Ubuntu 18.04*|*4GB* |*4*|
*k8sworker1* |*192.168.1.101*|*Ubuntu 18.04*|*16GB*|*4*|
*k8sworker2* |*192.168.1.102*|*Ubuntu 18.04*|*16GB*|*4*|
*k8sworker3* |*192.168.1.103*|*Ubuntu 18.04*|*16GB*|*4*|


<a id="deploy"></a>
## How to deploy kubernetes cluster ?

*Checkout the code  (git clone https://github.com/sunilnagavelli/k8s-installation.git)* 

## ***Step 1***

***Update host names for all nodes***

* `192.168.1.100 (k8smaster)`
* `192.168.1.101 (k8sworker1)`
* `192.168.1.102 (k8sworker2)`
* `192.168.1.103 (k8sworker3)`

***Unix Command!!!***

`$ nano /etc/hostname` 


## ***Step 2***

***Copy k8s-installation-ubuntu folder to all master/worker nodes***

* `192.168.1.100 (k8smaster)`
* `192.168.1.101 (k8sworker1)`
* `192.168.1.102 (k8sworker2)`
* `192.168.1.103 (k8sworker3)`

*Example copy to root folder and execution permissions can be applied by executing the below command.*

***Unix Command!!!***

`$ chmod +x -R k8s-installation-ubuntu` 


## ***Step 3***

***Execute the below script on all master/worker nodes***

* `192.168.1.100 (k8smaster)`
* `192.168.1.101 (k8sworker1)`
* `192.168.1.102 (k8sworker2)`
* `192.168.1.103 (k8sworker3)`

<img width="324" alt="etc-hosts-content" src="https://user-images.githubusercontent.com/40353788/56884000-02ffef00-6a86-11e9-80d4-3d89948ed345.png">

*Before executing the below script please don't forget to change the IP's and Host Names as per your requirements in the below script*


  ***Unix Command!!!***
  
 `$ k8s-installation-ubuntu/provisioning/prerequisites/install.sh`


## ***Step 4***

***Reboot all master/worker nodes***

* `192.168.1.100 (k8smaster)`
* `192.168.1.101 (k8sworker1)`
* `192.168.1.102 (k8sworker2)`
* `192.168.1.103 (k8sworker3)`

***Unix Command!!!***

 `$ reboot`

## ***Step 5***

***Execute the below script only on master nodes***

* `192.168.1.100 (k8smaster)`

***Unix Command!!!***

`$ cd k8s-installation-ubuntu/provisioning/vm-master`

`$ ./install.sh`


## ***Step 6***

***Execute the below script on all worker nodes***

* `192.168.1.101 (k8sworker1)`
* `192.168.1.102 (k8sworker2)`
* `192.168.1.103 (k8sworker3)`

<img width="449" alt="install.sh-workers" src="https://user-images.githubusercontent.com/40353788/56884270-d9939300-6a86-11e9-8e9e-fe7fc2681a49.png">

  ***Unix Command!!!***
  
`$ kubeadm token create --print-join-command`

*Before executing the ***below*** script please ***don't forget*** to change the ***token*** in the script. We can get the ***token*** by running the ***above*** command on* ***master node IP***  

  ***Unix Command!!!***
  
`$ cd k8s-installation-ubuntu/provisioning/vm-worker`

`$ ./install.sh`



## ***Step 7***

***Execute the below script only on master node IP to install HELM***

* `192.168.1.100 (k8smaster)`

***Unix Command!!!***

`$ cd k8s-installation-ubuntu/provisioning/helm`

`$ ./install.sh`

## ***Step 8***
***Verify k8s-installation is success by executing below two commands to see all the nodes and pods.***

***Unix Command!!!***

`$ kubectl get nodes`

`$ kubectl get pods -o wide --all-namespaces`


<a id="dashboard"></a>

## How to access Kubernetes Dashboard ?

*The ***Kubernetes Dashboard*** can be accessed via the below URL with your ***master node IP*** with the same port ***30070****

[http://192.168.1.100:30070/#!/overview?namespace=_all](http://192.168.1.100:30070/#!/overview?namespace=_all)


<a id="nfs-configuration"></a>

## How to install NFS Server ?


*Here we are going use master node IP as NFS Server IP instead of configuring separate node.*

*Execute the below command only on master node IP to install NFS-Client-Provisioner.*

*Note: Please don't forget to change nfs.server in the below unix command with your master node IP configured.*


***Unix Command!!!***

`$ helm install stable/nfs-client-provisioner --name nfs-client-provisioner --set nfs.server=192.168.1.100 --set nfs.path=/mnt/storage --set storageClass.defaultClass=true`

<a id="addons"></a>
## What are the addons provided ?
* `kubernetes dashboard`
* `helm`
