# refs :
# https://pve.proxmox.com/wiki/Cloud-Init_Support
# https://memo-linux.com/proxmox-deployer-une-machine-virtuelle-kvm-avec-cloud-init/
# https://access.redhat.com/documentation/fr-fr/red_hat_enterprise_linux/8/html-single/configuring_and_managing_cloud-init_for_rhel_8/index
# https://access.redhat.com/documentation/fr-fr/red_hat_enterprise_linux_openstack_platform/7/html-single/instances_and_images_guide/index


# remarque :
# Marko Myllynen
# The CPU features required by RHEL 8 and RHEL 9 are different. I saw kernel crashes with Packer/Qemu and filed a bug (https://bugzilla.redhat.com/show_bug.cgi?id=2094260), there RH Engineering pointed this RHBZ for background information:
# https://bugzilla.redhat.com/show_bug.cgi?id=2060839
# As you've noticed and as mentioned in the Packer/Qemu RHBZ, using 'host' as vCPU type will avoid the issue. Ideally tools would use supported libvirt instead of unsupported qemu-kvm at least over the long-term.
#

#  wget/curl download KVM/QEMU image from redhat website
#
qm create 1000 --name "rhel-9.1-cloudinit-template" --memory 2048 --net0 virtio,bridge=vmbr0
# Importer l’image précédemment téléchargée et définir le stockage :
qm importdisk 1000 rhel-baseos-9.1-x86_64-kvm.qcow2 local-lvm
# Attacher le nouveau disque sur la VM comme disque SCSI :
 qm set 1000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-1000-disk-0
# Ajouter un disque de type cloud-init :
qm set 1000 --ide2 local-lvm:cloudinit
# Définir sur quel disque démarrer :
qm set 1000 --boot c --bootdisk scsi0
# Ajouter une interface VGA pour l’accès à la console sous Proxmox :
qm set 1000 --serial0 socket --vga serial0
# Dernière étape, transformer la VM en modèle de machine virtuelle :
qm template 1000
