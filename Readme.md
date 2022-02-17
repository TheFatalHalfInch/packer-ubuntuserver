
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
