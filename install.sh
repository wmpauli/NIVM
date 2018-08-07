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

# unfortunately things get a little ugly if the system is installing updates or key servers are down, while we are trying to add repos or install packages. We therefore wrap important commands in this function, which tries a command repeatedly, until successful or a maximum total number of attempts has been reached.
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
max=720 # total number of retries
sleep_duration=5 # how many seconds to wait in between retries

# add neurodebian repository
cmd="wget -O /etc/apt/sources.list.d/neurodebian.sources.list http://neuro.debian.net/lists/xenial.us-nh.full"
eval_cmd $cmd

# add certificate keys
cmd="apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9"
eval_cmd $cmd

# update package cache
cmd="apt-get update"
eval_cmd $cmd

# install packages
cmd="apt-get install -y afni connectome-workbench connectomeviewer fsl-core fsleyes fsl-harvard-oxford-atlases itksnap"
eval_cmd $cmd

# remove obsolete packages
cmd="apt-get -y autoremove"
eval_cmd $cmd

# configure FSL
cd /tmp/
wget https://raw.githubusercontent.com/wmpauli/NIVM/master/fsl_configure.sh
mv fsl_configure.sh /etc/profile.d/

# ensure that these settings also work in non-login shells
echo "source /etc/profile.d/fsl_configure.sh" | tee --append /etc/bash.bashrc
