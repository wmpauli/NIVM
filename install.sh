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

function eval_cmd() {
  "$@"
  while [ $? -ne 0 ]; do
    if [ "$i" -gt "$max" ]; then
      break
    fi
    ((i=i+1))
    echo "Sleeping for $sleep_duration seconds."
    sleep $sleep_duration
    echo "Retrying: $cmd"
    "$@"
  done
}

# counter of failed attempts
i=0
max=50
sleep_duration=5

# add neurodebian repository
cmd="wget -O /etc/apt/sources.list.d/neurodebian.sources.list http://neuro.debian.net/lists/xenial.us-nh.full"
eval_cmd $cmd

# add certificate keys
cmd="apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9"
eval $cmd
while [ $? -ne 0 ]; do
  if [ "$i" -gt "$max" ]; then
    break
  fi
  ((i=i+1))
  echo "Sleeping for $sleep_duration seconds."
  sleep $sleep_duration
  echo "Retrying: $cmd"
  eval $cmd
done

# update package cache
cmd="apt-get update"
eval $cmd
while [ $? -ne 0 ]; do
  if [ "$i" -gt "$max" ]; then
    break
  fi
  ((i=i+1))
  echo "Sleeping for $sleep_duration seconds."
  sleep $sleep_duration
  echo "Retrying: $cmd"
  eval $cmd
done

# install packages
cmd="apt-get install -y afni connectome-workbench connectomeviewer fsl-core fsleyes fsl-harvard-oxford-atlases itksnap"
eval $cmd
while [ $? -ne 0 ]; do
  if [ "$i" -gt "$max" ]; then
    break
  fi
  ((i=i+1))
  echo "Sleeping for $sleep_duration seconds."
  sleep $sleep_duration
  echo "Retrying: $cmd"
  eval $cmd
done

# remove obsolete packages
cmd="apt-get -y autoremove"
eval $cmd
while [ $? -ne 0 ]; do
  if [ "$i" -gt "$max" ]; then
    break
  fi
  ((i=i+1))
  echo "Sleeping for $sleep_duration seconds."
  sleep $sleep_duration
  echo "Retrying: $cmd"
  eval $cmd
done

# configure FSL
cd /tmp/
wget https://raw.githubusercontent.com/wmpauli/NIVM/master/fsl_configure.sh
mv fsl_configure.sh /etc/profile.d/

# ensure that these settings also work in non-login shells
echo "source /etc/profile.d/fsl_configure.sh" | tee --append /etc/bash.bashrc
