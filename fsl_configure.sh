# configure bash shell for FSL

FSLDIR=/usr/share/fsl/5.0
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH
