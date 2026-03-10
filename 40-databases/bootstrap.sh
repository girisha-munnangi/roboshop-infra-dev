#!/bin/bash
component=$1
environment=$2
dnf install ansible -y
cd /home/ec2-user
git clone https://github.com/girisha-munnangi/ansible-roboshop-roles-tf.git
cd ansible-roboshop-roles
ansible-playbook -e component=$component -e environment=$environment robo.yaml
