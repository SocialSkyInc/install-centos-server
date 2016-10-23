#!/bin/bash

source log.sh


IP=$1
if [ "${IP}" != "" ]; then
	log "setting static ip address"
	sed -i s/.50/.${IP}/g /etc/sysconfig/network-scripts/ifcfg-en
	systemctl restart network.service
fi

log "switch to aliyun yum source"
pushd /etc/yum.repos.d

mv CentOS-Base.repo CentOS-Base.repo.bak
wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache

popd

log "install zsh and oh-my-zsh"
yum -y install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

log "install shadowsocks"
yum -y install python-setuptools
easy_install pip
pip install shadowsocks

log "install proxychains-ng"
git clone git@github.com:john-deng/proxychains-ng.git
yum -y install gcc g++
pushd proxychains-ng
make && make install
cp src/proxychains.conf /etc/
popd

log "installed common tools"