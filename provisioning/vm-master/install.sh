#!/bin/bash
apt-get update -y
apt-get install -y figlet
figlet MASTER

echo "[TASK 2] Start master"
kubeadm init --ignore-preflight-errors all --pod-network-cidr=192.168.2.10/24 --token-ttl 0

echo "[TASK 3] Install Calico"
if [ -f calico.yaml ]; then
  echo 'proceeding with the existing calico config'
else
 curl \
   https://docs.projectcalico.org/v3.6/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml \
   -O
 POD_CIDR=92.168.2.10/24
 sed -i -e "s?192.168.0.0/16?$POD_CIDR?g" calico.yaml
 kubectl apply -f calico.yaml

echo "[TASK 4] Display PODS"
 kubectl get pods --all-namespaces

echo "[TASK 5] Install kubeconfig"
 mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config

echo "[TASK 6] Install Dashboard"
kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f kubernetes-dashboard-rbac.yaml

echo "[TASK 7] Display All Services"
kubectl get services -n kube-system 

figlet NFS
apt-get install -y nfs-kernel-server
apt-get install -y nfs-common

mkdir -p /mnt/storage
cat >>/etc/hosts<<EOF
/mnt/storage *(rw,sync,no_root_squash,no_subtree_check)
EOF
systemctl restart nfs-kernel-server
exportfs -a

chown $(id -u):$(id -g) $HOME/.kube/config