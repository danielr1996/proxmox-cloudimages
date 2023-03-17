#apt -y install libguestfs-tools

vm_id='9000'
cloud_image_url='https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img'
template_name='ubuntu-22.04-jammy'
storage_location='local-lvm'
scsihw='virtio-scsi-pci'
memory='512'
cores='1'
# bridge='vmbr0'

if [ -z $1 ];then
    download_name='jammy.img'
    rm -rf $download_name
    wget ${cloud_image_url} -O ${download_name}
else
    download_name=$1
fi

# Cleanup
qm destroy ${vm_id}

# Prepare image
 virt-customize --update -a ${download_name}
 virt-customize --install qemu-guest-agent,cloud-init -a ${download_name} --truncate /etc/machine-id

# import image
# --net0 virtio,bridge=${bridge}
 qm create ${vm_id} --memory ${memory} --cores ${cores}  --name ${template_name} --tags ubuntu,ubuntu-jammy,ubuntu22.04
 qm importdisk ${vm_id} ${download_name} ${storage_location}
 qm set ${vm_id} --scsihw ${scsihw} --scsi0 ${storage_location}:vm-${vm_id}-disk-1
#  qm set ${vm_id} --ide0 ${storage_location}:cloudinit
 qm set ${vm_id} --boot c --bootdisk scsi0
#  qm set ${vm_id} --agent enabled=1
 qm template ${vm_id}
