
# Welcome!

This is a packer template for a base install of Ubuntu 20.04 using vsphere.

## Requirements

- Packer (https://www.packer.io/downloads)
- A vSphere environment

## How to use this template

- Clone the repo
- Create a pkrvars.hcl file with your variables somewhere on your computer
- CD into the cloned directory  
    packer build --var-file="c:\path\to\your\pkrvars.hcl" Ubuntu-20.04.pkr.hcl
    
## Defaults
Username: ubuntu  
Password: ubuntu

https://stackoverflow.com/questions/67457987/ubuntu-server-installation-stops-at-curtin-command-in-target  
https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html  
https://stackoverflow.com/questions/43674019/cloud-init-not-working-for-nocloud-datasource  
https://www.packer.io/plugins/builders/virtualbox/iso#gfx_vram_size  
https://askubuntu.com/questions/1389146/ubuntu-20-04-3-server-autoinstall-user-data-does-bootorder-efibootmgr-not-change  
https://gist.github.com/bitsandbooks/6e73ec61a44d9e17e1c21b3b8a0a9d4c  
https://ubuntu.com/server/docs/install/autoinstall-reference  