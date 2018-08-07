#!/bin/bash

# This script does a couple of things:
# 1. adding software repositories relevant for neuroimaging analysis
# 2. installing the software

# overload apt-get so that it waits if some other process is installing packages
cd /tmp/
wget https://raw.githubusercontent.com/wmpauli/NIVM/master/apt-get
chmod +x apt-get
sudo mv apt-get /usr/local/sbin/

# add neurodebian repository
wget -O- http://neuro.debian.net/lists/xenial.us-nh.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list

# add certificate keys
sudo apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9

# update package cache
sudo apt-get update

# install packages
# the following packages appear to be unavailable on neurodebian.org (for ubuntu 16.04): caret, *openmeeg*, pydicom
# we are also not installing spm, because that would require prior installation of matlab by the user
# we are installing fsleyes instead of fslview
# sudo apt-get install -y afni afni-common afni-dbg afni-dev connectome-workbench connectome-workbench-dbg connectomeviewer dcm2niix python-dcmstack debruijn dicomnifti fsl-core fsleyes heudiconv itksnap mriconvert mricron mricron-data mricron-doc mridefacer python-nibabel python-nibabel-doc python3-nibabel libnifti-dev libnifti-doc libnifti2 nifti-bin python-nipy python-nipy-doc python-nipy-lib python-nipy-lib-dbg python-nipype python-nipype-doc python-nitime python-nitime-doc python-dicom python3-dicom python-mvpa2 python-mvpa2-doc python-mvpa2-lib python-nifti python-pyxnat python-statsmodels python-statsmodels-doc python-statsmodels-lib voxbo fsl-harvard-oxford-atlases

# minimal installation
sudo apt-get install -y afni connectome-workbench connectomeviewer fsl-core fsleyes fsl-harvard-oxford-atlases itksnap 

# remove obsolete packages
sudo apt-get -y autoremove

# configure FSL
cd /tmp/
wget https://raw.githubusercontent.com/wmpauli/NIVM/master/fsl_configure.sh
sudo mv fsl_configure.sh /etc/profile.d/

# ensure that these settings also work in non-login shells
echo "source /etc/profile.d/fsl_configure.sh" | sudo tee --append /etc/bash.bashrc

# install servers for remote access
sudo apt-get install -y x2goserver
