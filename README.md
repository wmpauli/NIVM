# NIVM

This repository provides the Neuroimaging extension for the Data Science Virtual Machine ([DSVM](https://azure.microsoft.com/en-us/services/virtual-machines/data-science-virtual-machines/)), a customized VM image on Microsoft’s Azure ([wikipedia](https://en.wikipedia.org/wiki/Microsoft_Azure)) for Neuroimaging research. The central goal of this extension is to enable neuroimaging scientists to have easy access to scalable computing and storage resources for their research projects. The central aim of this project is to make the transition to the cloud as simple as possible. See documentation below for details, including how to try the extension for free.

Once you are ready to try it out, press this button to deploy this VM to Microsoft Azure: <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fwmpauli%2FNIVM%2Fmaster%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>


## Incentives for moving to the cloud

Currently, many researchers are running their analyses on desktop computers or even their laptops. In some cases, neuroimaging laboratories have acquired an expensive on-premises computing and storage cluster with something like 50TB of storage and 30 computing cores. In rare circumstances do laboratories take advantage of shared computing resources provided by the host institute (e.g. university) for its entire scientific community. 

Using the cloud allows scientists to quickly resize their virtual machine, from only sporting a dual-core CPU to several GPUs ([DLVM](https://docs.microsoft.com/en-us/azure/machine-learning/data-science-virtual-machine/deep-learning-dsvm-overview)).  It is even possible to deploy a farm of VMs for rapid speed-up. Similarly, storage capacity can be flexibly increased and decreased on demand, not requiring researchers to buy a large amount of expensive redundant storage to safeguard against running out of space.

Consider how neuroimaging analyses would benefit from running on the cloud:

### Performance and Storage space

- MRI analyses require execution of complicated pipelines that are both time-consuming and computationally intensive, computing jobs typically run for hours and days. Requiring researchers to keep their laptops or workstations running.
- Each neuroimaging project requires about 2TB of data, forcing labs to purchase large amounts of redundant storage, as data must be stored securely for many years, per request of federal (NIH, NSF) and many private funding agencies.


### Scalability
 
- Neuroimaging jobs are highly parallelizable. For example, each participants' data can be processed independently. Parameter and model selection can also be performed in parallel.
- Many NI packages support GPUs, but GPUs aren’t required in every step of the analysis process. Ability to switch between cheaper and slower CPU VMs (DSVM) and more expensive and much faster GPU VMs (DLVM) would be beneficial.
- Advanced data analysis techniques have led to impressive improvements of analysis results, but are also computationally intensive. They often also require the storage of intermediate results, which can take a lot of storage space for a limited amount of time.


### Recent developments that favor cloud computing

- Since the advent of data-sharing initiatives, many data sets are online and can be shared by scientists. Microsoft is currently considering to mirror the most essential of these data sets, so that their storage wouldn't have to be paid for.
- Increases of MRI scanner magnetic field strengths and improvements to data acquisition protocols have enabled higher-resolution data sets, requiring larger amounts of storage, and more time/cycles to process.
- Many current analysis approaches require permutation testing, to establish empirically what the likelihood of the found results is, given that there is no true effect in the data. Permutation testing is computationally intensive, as the same analyses must be run 100s or 1000s of times on simulated (hypothetical) data.


### Reproducibility

- VMs can be captured, and images of the VM can be downloaded. This will benefit efforts of increasing the reproducibility of published scientific findings. VM machine images will contain all the data, and analysis script need to reproduce the published results. (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4936733/)


# Overview of extension

Operating System: [Ubuntu](http://releases.ubuntu.com/16.04/) Linux Data Science Virtual Machine, associated with Neurodebian.org for package management. (An extension for Windows 10 may also be created, if there is demand for it.)
 
This DSVM extension for neuroimaging strongly relies on packages available through the NeuroDebian.ORG software repository. Specifically, this extension contains all software listed on this [page](http://neuro.debian.net/pkglists/toc_pkgs_for_field_mri.html#toc-pkgs-for-field-mri). 

The extension also comes w/ **Docker support**, making it easy to [install fmriprep](https://fmriprep.readthedocs.io/en/latest/installation.html). 

**Note:** Matlab and SPM are currently not pre-installed with this extension.  Please let us know of a good way of doing this without having a matlab license.


# Getting started: 

Go to Microsoft Azure [portal](http://portal.azure.com), to create a free account. This will let you try this extension for free. 

It may be benefitial to do briefly browse the [help] pages for Microsoft Azure (https://ms.portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade/overview).

## Workflow

The very first step is to provision and deploy a Data Science Virtual Machine (DSVM) with this extension (click button above).
 
At the very core, using this extension requires the following steps:
1. Look up the IP address of your virtual machine after booting it up.
2. Upload your data using e.g. rsync, scp. It is recommended to store the data in `/data`. Note that it is easy to add additional hard-drives to your VM.
3. Use your preferred remote desktop client to connect to your virtual machine (via VNC). You can also use ssh for a command line interface.

# Existing Cloud solutions 

- NITRC - AWS: https://aws.amazon.com/marketplace/pp/B00DLI6VAQ?qid=1532479591110
- Stanford Center for Reproducible Neuroscience: https://openneuro.org/

# Further Reading:

- https://www.frontiersin.org/articles/10.3389/fninf.2017.00063/full

# Contribute

Please feel free to fork this repository, if you want to have other/additional software installed. Any augmentation of the documentation for this extension is of course also more than welcome. Please create a pull request if you think it worthwhile merging your fork with the main branch.
