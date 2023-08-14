#!/bin/bash


sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
echo "RUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"" >> /etc/default/grub
update-grub
update-grub2
#apt-get -t jessie-backports install systemd

sleep 5

apt update -y
 
echo -en  "\033[32m--------INSTALL TERRAFORM----------\033[42m"


cp /home/ubuntu/.terraformrc /root/.terraformrc
mv /home/ubuntu/terraform /bin/terraform
chmod +x /bin/terraform
cp /home/ubuntu/config /root/.ssh/config
cp /home/ubuntu/id_rsa.pub /home/ubuntu/.ssh/id_rsa.pub
cp /home/ubuntu/id_rsa /home/ubuntu/.ssh/id_rsa
mv /home/ubuntu/id_rsa.pub /root/.ssh/id_rsa.pub
mv /home/ubuntu/id_rsa /root/.ssh/id_rsa

echo -en  "\033[32m--------INSTALL GIT----------\033[42m"

apt install apt-transport-https ca-certificates curl software-properties-common git -y

echo -en  "\033[32m--------INSTALL DOCKER----------\033[42m"

curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
systemctl enable docker.service && systemctl enable containerd.service && systemctl start docker.service && sudo systemctl start containerd.service

echo -en  "\033[32m--------INSTALL PIP ANSIBLE JQ----------\033[42m"

sudo apt install software-properties-common -y

add-apt-repository ppa:deadsnakes/ppa -y
apt install python3-pip -y
apt-get install jq ansible -y
#apt-get install python-jinja2=2.8-1~bpo8+1 python-netaddr -y

echo -en  "\033[32m--------INSTALL KUBEADM KUBECTL----------\033[42m"

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list 
apt-get update
apt-get install -y kubeadm kubectl
apt-mark hold kubeadm kubectl

echo -en  "\033[32m--------INSTALL HELM----------\033[42m"

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update 
apt-get install helm -y

echo -en  "\033[32m--------INSTALL GITLUB-RUNNER----------\033[42m"

curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash 
apt-get update
apt-get install gitlab-runner -y
systemctl enable gitlab-runner --now


echo -e " "
echo -en  "\033[32m#---------------TERRAFORM VERSION----------\033[42m"
terraform --version
echo -e " "
echo -en  "\033[32m#---------------GIT VERSION----------------\033[42m"
git --version
echo -e " "
echo -en  "\033[32m#---------------DOCKER VERSION-------------\033[42m"
docker --version
echo -e " "
echo -en  "\033[32m#---------------DOCKER COMPOSE-VERSION-----\033[42m"
docker compose version
echo -e " "
echo -en  "\033[32m#---------------PIP VERSION----------------\033[42m"
pip --version
echo -e " "
echo -en  "\033[32m#---------------ANSIBLE VERSION------------\033[42m"
ansible --version
echo -e " "
echo -en  "\033[32m#---------------KUBECTL VERSION------------\033[42m"
kubectl version
echo -e " "
echo -en  "\033[32m#---------------KUBEADM VERSION------------\033[42m"
kubeadm version
echo -e " "
echo -en  "\033[32m#---------------GITLUB-RUNNER VERSION------\033[42m"
gitlab-runner --version
echo -e " "
echo -en  "\033[32m#---------------HELM VERSION---------------\033[42m"
helm version
echo -e " "
echo -en  "\033[32m#---------------JQ VERSION------------------\033[42m"
jq --version


cd /opt
git clone git@github.com:usmanofff/kubespray_setup.git
cd kubespray_setup
git clone git@github.com:usmanofff/kubespray.git
pip3 install -r /opt/kubespray_setup/kubespray/requirements.txt
                                                


chmod +x /opt/kubespray_setup/cluster_install.sh
chmod +x /opt/kubespray_setup/cluster_destroy.sh
chmod +x /opt/kubespray_setup/terraform/generate_credentials_velero.sh
chmod +x /opt/kubespray_setup/terraform/generate_etc_hosts.sh
chmod +x /opt/kubespray_setup/terraform/generate_inventory.sh
mv /home/ubuntu/private.variables.tf /opt/kubespray_setup/terraform/private.variables.tf

echo "private_key_file = /home/ubuntu/.ssh/id_rsa.pub" >> /etc/ansible/ansible.cfg
echo "private_key_file = /home/ubuntu/.ssh/id_rsa.pub" >> /opt/kubernetes_setup/kubespray/ansible.cfg
chmod 700 /home/ubuntu/.ssh/
chmod 700 /root/.ssh/
chmod 600 /home/ubuntu/.ssh/id_rsa
chown -R ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
chown -R root:root /root/.ssh/id_rsa
chmod 644 /home/ubuntu/.ssh/id_rsa.pub
chown -R ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa.pub
chmod 644 /root/.ssh/id_rsa.pub
chown -R root:root /root/.ssh/id_rsa.pub
apt-get autoremove -y
apt-get autoclean -y
echo -en  "\033[32m#---------------install complite------------------\033[42m"

cd /opt/kubernetes_setup && ./cluster_install.sh