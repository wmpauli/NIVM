#!/bin/bash

# This script does a couple of things:
# 1. adding software repositories relevant for neuroimaging analysis
# 2. installing the software

# unfortunately things get a little ugly if the OS is installing updates, or key servers are down, while we are trying to add repos or install packages. We therefore wrap important commands in this function, which tries a command repeatedly, until successful or a maximum total number of attempts has been reached.
function eval_cmd() {
  "$@"
  while [ $? -ne 0 ]; do
    if [ "$i" -gt "$max" ]; then
      echo "Exceeded maximum attempts (${max})."
      break
    fi
    ((i=i+1))
    echo "Sleeping for $sleep_duration seconds."
    sleep $sleep_duration
    echo "Retrying: $@"
    "$@"
  done
}

i=0 # counter of failed attempts
max=240 # total number of retries
sleep_duration=15 # how many seconds to wait in between retries

# update the keys for the tensorflow repository
cmd="wget -O /tmp/tensorflow-serving.release.pub.gpg https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg"
eval_cmd $cmd
cmd="apt-key add /tmp/tensorflow-serving.release.pub.gpg"
eval_cmd $cmd

# add neurodebian repository
cmd="wget -O /etc/apt/sources.list.d/neurodebian.sources.list http://neuro.debian.net/lists/xenial.us-nh.full"
eval_cmd $cmd

# add certificate keys
cmd="apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9"
eval_cmd $cmd

# update package cache
cmd="apt-get update"
eval_cmd $cmd

# update all packages
ACCEPT_EULA=Y
cmd="apt-get -y dist-upgrade"
eval_cmd $cmd

# install packages
cmd="apt-get install -y afni connectome-workbench connectomeviewer itksnap"
eval_cmd $cmd

# remove obsolete packages
cmd="apt-get -y autoremove"
eval_cmd $cmd

# manually install fsl, so we can put it the larger data partition (which can be resized)
mkdir /data/tmp
wget -O /data/tmp/fslinstaller.py https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py
sed -i 's/mkstemp()/mkstemp(dir\=\"\/data\/tmp\")/' /data/tmp/fslinstaller.py
/usr/bin/python2.7 /data/tmp/fslinstaller.py -d /data/fsl

# configure FSL
wget -O /etc/profile.d/fsl_configure.sh https://raw.githubusercontent.com/wmpauli/NIVM/master/fsl_configure.sh

# ensure that these settings also work in non-login shells
echo "source /etc/profile.d/fsl_configure.sh" | tee --append /etc/bash.bashrc

# last and worst, now we need to update the OpenGL version for fsleyes.
mkdir /data/mesa
cd /data/mesa
apt-get install -y aptitude
aptitude -y build-dep mesa
aptitude -y install scons llvm-dev
apt-get -y source mesa
cd mesa-18.0.5
scons libgl-xlib
echo "LD_LIBRARY_PATH=`pwd`/build/linux-x86_64-debug/gallium/targets/libgl-xlib/:${LD_LIBRARY_PATH}" | tee --append /etc/bash.bashrc
