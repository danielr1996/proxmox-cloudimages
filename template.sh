#apt -y install libguestfs-tools

vm_id='9000'
cloud_image_url='https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img'
template_name='ubuntu-22.04-jammy'
storage_location='local-lvm'
scsihw='virtio-scsi-pci'
memory='512'
cores='1'

# if no argument is set download the image from cloud_image_url
if [ -z $1 ];then
    download_name='jammy.img'
    rm -rf $download_name
    wget ${cloud_image_url} -O ${download_name}
# if an argument is set, use that as the location for a preloaded .img
else
    download_name=$1
fi

qm destroy ${vm_id}

# the --truncate option is really important here, because it will reset /etc/machine-id to be empty, so it will be populated at each first boot 
# of the cloned vm. Without it each cloned vm would inherit the machine-id from this template. This is neccessary because tools like k0s rely on 
# this to uniquely identify a machine
virt-customize --update -a ${download_name}
virt-customize --install qemu-guest-agent,cloud-init -a ${download_name} --truncate /etc/machine-id

qm create ${vm_id} --memory ${memory} --cores ${cores}  --name ${template_name} --tags ubuntu,ubuntu-jammy,ubuntu22.04
qm importdisk ${vm_id} ${download_name} ${storage_location}
qm set ${vm_id} --scsihw ${scsihw} --scsi0 ${storage_location}:vm-${vm_id}-disk-1
qm set ${vm_id} --boot c --bootdisk scsi0
qm template ${vm_id}
