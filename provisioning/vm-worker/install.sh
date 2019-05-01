#!/bin/bash

figlet WORKER

figlet NFS
apt-get install -y nfs-common

echo "[TASK 1] Start the services"
systemctl start docker && systemctl enable docker
systemctl start kublet && systemctl enable kubelet

echo "[TASK 1] Join master"
#Update the join token by executing the command on master node
#kubeadm token create --print-join-command
kubeadm join 192.168.1.100:6443 --token ek8rsu.x3woyary4t73hlwu --discovery-token-ca-cert-hash sha256:4faa46819616d4ca97533d77b578617b47f321bd1ce1b43c5ad430919d0d291c
