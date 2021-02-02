#!/bin/bash

umask 007

PUBLIC_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDt01uJaUK35vZVgmc3QL8k2TYLeHJRFEOTlItdDbDZh6Yuc4bLw3Y0qhPEovzRlNEDdI5LzxpwQCBCIdHhpb5Jtrc3T4+bAogxnkEHWRYMPusrdbHwEr1JE6XiuD282qD0RE2PsNq5rg9lt66IqdjaHwHfk8CbOn9EQu1BaBIVAbIFd074x8COP8xsQRTjNuOZv3wmeoPyn4Xugj9tmotH/EUGEian7t3SNxkqQ0BVOxZJPGYf9tmRiyymci6MLKf+t+OVjqXqJFfkN2QEvJVl837COzjstlTItuMDKApPCSRn7OXrB/FG9WWd5/4nEKIIDEoB/EVhftw3MUVtofvR jun@junaire.com'

is_root(){
	[ "${EUID}" -ne 0 ] && echo "The script must be ran as root!" && exit 1
}

config_ssh(){
	if ! [ -d "~/.ssh" ] ;
	then
		mkdir -p ~/.ssh
		chmod 700 ~/.ssh
	fi

	[ -z "${PUBLIC_KEY}" ] && echo "Please configure your ssh public key!" && exit 1
	echo "${PUBLIC_KEY}" > ~/.ssh/authorized_keys

	chmod 644 ~/.ssh/authorized_keys


	sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
	sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

	systemctl restart sshd.service
}

install_tools(){
	yum update && yum upgrade
	yum install vim git wget curl tree -y
	yum install openssl openssl-devel zlib zlib-devel pcre pcre-devel gcc gcc-c++ epel-release yum-utils -y
}

is_root
config_ssh
install_tools
