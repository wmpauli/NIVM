# add neurodebian repository
wget -O- http://neuro.debian.net/lists/xenial.us-nh.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list

# add certificate keys
sudo apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9

# create fake matlab executable to allow the installation of matlab
sudo echo "echo \"Matlab is not installed, please install manually, in '/usr/local/matlab/'.\"" > /tmp/matlab
chmod a+x /tmp/matlab
sudo mkdir -p /usr/local/matlab/bin
sudo mv /tmp/matlab !$
sudo ln -s /usr/local/matlab/bin/matlab /usr/local/bin/

# update package cache
sudo apt-get update

# install tool which enables preconfiguration of packages before installation, so that matlab-spm8 can be install non-interactively
sudo apt install debconf-utils

# install packages
# the following packages appear to be unavailable on neurodebian.org (for ubuntu 16.04): caret, *openmeeg*, pydicom
# we are also not installing spm, because that would require prior installation of matlab by the user
# we are installing fsleyes instead of fslview
sudo apt-get install -y afni afni-common afni-dbg afni-dev connectome-workbench connectome-workbench-dbg connectomeviewer dcm2niix python-dcmstack debruijn dicomnifti fsl-core fsleyes fslview-doc heudiconv itksnap mriconvert mricron mricron-data mricron-doc mridefacer python-nibabel python-nibabel-doc python3-nibabel libnifti-dev libnifti-doc libnifti2 nifti-bin python-nipy python-nipy-doc python-nipy-lib python-nipy-lib-dbg python-nipype python-nipype-doc python-nitime python-nitime-doc python-dicom python3-dicom python-mvpa2 python-mvpa2-doc python-mvpa2-lib python-nifti python-pyxnat python-statsmodels python-statsmodels-doc python-statsmodels-lib voxbo fsl-harvard-oxford-atlases

# remove obsolete packages
sudo apt-get autoremove

# update pip
pip install --upgrade pip

# install fmriprep-docker
pip install --user --upgrade fmriprep-docker



