#!/bin/bash
growpart /dev/nvme0n1 4
lvextend -r -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

yum update -y
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform