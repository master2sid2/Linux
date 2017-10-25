#!/bin/bash

private_key=$1
servers_list=( 213.160.152.100 )

my_private_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkHy2OScOTrfZ/IXSDIP80iktuMU5QplxybZPBEr0+fLEHL7pzW9Mv9fxJ4+K6x5enJDrrxEmEh1/4Y8Gv0RXnBeyA1IwbSvxPW5hf5QLg3czuWXNrEuqwSijb+7OS8QyN2jE6JwV4QWJ0UP2Rvq0FijHCdgAdGt4YOLIYE84oWXi0htf4N70sjXdEpZomDjicJaMHWTPun0fvWOR3lljIzh/jG9d9tQPhKNAgV1CPW1635M1Moffd2uIZrpBB7yqTiQhtnHyg7bBSAMFrjfJsycM7CCCZXg4P2fJZfWPtTaXHGD68YfOh+XVpaSIpUNFercjc1yG8wZnZLLenpeE7 root@Centos"

for server in ${servers_list[@]}; do
	echo "Trying to connect to $server server"
	connect=`ssh itsource@$server "cat ~/.ssh/authorized_keys | grep \"$private_key\""`
	echo $connect
done
