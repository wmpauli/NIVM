#!/bin/bash

# This script does a couple of things:
# 1. adding software repositories relevant for neuroimaging analysis
# 2. installing the software

# overload apt-get so that it waits if some other process is installing packages
# cd /tmp/
# wget https://raw.githubusercontent.com/wmpauli/NIVM/master/apt-get
# chmod +x apt-get
# sudo mv apt-get /usr/local/sbin/

# add neurodebian repository
wget -O- http://neuro.debian.net/lists/xenial.us-nh.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list

# add certificate keys
sudo apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9

# update package cache
sudo apt-get update

# install packages
sudo apt-get install -y afni connectome-workbench connectomeviewer fsl-core fsleyes fsl-harvard-oxford-atlases itksnap 

# remove obsolete packages
sudo apt-get -y autoremove

# configure FSL
cd /tmp/
wget https://raw.githubusercontent.com/wmpauli/NIVM/master/fsl_configure.sh
sudo mv fsl_configure.sh /etc/profile.d/

# ensure that these settings also work in non-login shells
echo "source /etc/profile.d/fsl_configure.sh" | sudo tee --append /etc/bash.bashrc
