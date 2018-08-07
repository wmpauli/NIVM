#!/bin/bash

# This script does a couple of things:
# 1. adding software repositories relevant for neuroimaging analysis
# 2. installing the software

# # overload apt-get so that it waits if some other process is installing packages
# cd /tmp/
# wget https://raw.githubusercontent.com/wmpauli/NIVM/master/apt-get
# chmod +x apt-get
# mv apt-get /usr/local/sbin/

# # overload apt-key so that it waits if some other process is installing packages
# cd /tmp/
# wget https://raw.githubusercontent.com/wmpauli/NIVM/master/apt-key
# chmod +x apt-key
# mv apt-key /usr/local/sbin/

# add neurodebian repository
wget -O- http://neuro.debian.net/lists/xenial.us-nh.full | tee /etc/apt/sources.list.d/neurodebian.sources.list
while [ $? -ne 0 ]; do !!; done

# add certificate keys
apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
while [ $? -ne 0 ]; do !!; done

# update package cache
apt-get update
while [ $? -ne 0 ]; do !!; done

# install packages
apt-get install -y afni connectome-workbench connectomeviewer fsl-core fsleyes fsl-harvard-oxford-atlases itksnap 
while [ $? -ne 0 ]; do !!; done

# remove obsolete packages
apt-get -y autoremove
while [ $? -ne 0 ]; do !!; done

# configure FSL
cd /tmp/
wget https://raw.githubusercontent.com/wmpauli/NIVM/master/fsl_configure.sh
mv fsl_configure.sh /etc/profile.d/

# ensure that these settings also work in non-login shells
echo "source /etc/profile.d/fsl_configure.sh" | tee --append /etc/bash.bashrc
