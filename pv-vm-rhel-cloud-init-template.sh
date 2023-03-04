# refs :
# https://pve.proxmox.com/wiki/Cloud-Init_Support
# https://memo-linux.com/proxmox-deployer-une-machine-virtuelle-kvm-avec-cloud-init/
# https://access.redhat.com/documentation/fr-fr/red_hat_enterprise_linux/8/html-single/configuring_and_managing_cloud-init_for_rhel_8/index

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
