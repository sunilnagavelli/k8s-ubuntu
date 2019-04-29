#!/bin/bash
apt-get update -y

figlet PREREQUISITES

echo "[TASK 1] Add hosts to etc/hosts"
echo "">>/etc/hosts
echo "K8s Config">>/etc/hosts

input="../hosts.properties"
while IFS= read -r host
  do
    host_name=$(echo $host | awk -F"=" '{print $1}');
    host_ip=$(echo $host | awk -F"=" '{print $2}');
    echo "$host_ip    $host_name">>/etc/hosts
  done < "$input"

echo "[TASK 2] Disable Swap"
swapoff -a && sed -i '/swap/d' /etc/fstab

echo "[TASK 3] openssh-server"
apt-get install openssh-server -y

echo "[TASK 4] Install Docker"
apt-get install ca-certificates curl apt-transport-https gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io -y

echo "[TASK 5] Add Kubernetes Repositories"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "[TASK 6] Install kubelet/kubeadm/kubectl"
apt-get update -y
apt-get install -y kubelet kubeadm kubectl 
sed -i 's/cgroup-driver=systemd/cgroup-driver=cgroupfs/g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "[TASK 7] Start and enable servcies"
sudo service docker start
sudo usermod -aG docker ${USER}

echo "Installation completed"
