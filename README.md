# proxmox-cloudimages

> heavily inspired by the following posts / projects
> * https://austinsnerdythings.com/2023/01/10/proxmox-ubuntu-22-04-jammy-lts-cloud-image-script/
> * https://github.com/TechByTheNerd/cloud-image-for-proxmox
> 
> However, since I will use these images mainly to create VMs via IaC solutions like pulumi or terraform my scripts are much simpler and do only the absolute bare minimum to create a template, leaving everything else like adding sshkeys, network config or even the network interface itself to the the IaC solution. 

## Usage
Run on of these commands on your workstation that can connect to your proxmox host at <user@host> over ssh, alternatively checkout `template.sh` and run it directly on the proxmox host
```
# Download image
curl https://raw.githubusercontent.com/danielr1996/proxmox-cloudimages/main/template.sh | ssh <user@host> 'bash -'
# use image "image.qcow2"
curl https://raw.githubusercontent.com/danielr1996/proxmox-cloudimages/main/template.sh | ssh <user@host> 'bash /dev/stdin image.qcow2'
```

This script assumes a few things about your proxmox environment, namely: 
* the ID of the template will be 9000
* the lates ubuntu jammy image will be downloaded
* the template will be stored on 'local-lvm'
* the disk will be attached with 'virtio-scsi-pci'

If you need to change any of these, download the script and edit the values on top