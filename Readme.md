# Ubuntu Linux virtualized using Vagrant/libvirt
project uses the following components:
- host system is Ubuntu 20.04 LTS

- runs on an Ubuntu 20.04 server

- virtual machine is deployed using Vagrant IAC

- Vagrant uses the non-standard libvirt provider, i.e. QEMU/KVM hypervisor

There are two further provisioning options defined so far:
    
  1. a very basic NGINX setup  
  &rightarrow; sample website is fetched from a generic code repository using git

  2. a basic docker installation  
  &rightarrow; testing an image pull from tutorial: *docker/getting-started:latest*

## requirements on host
1. QEMU/KVM hypervisor with a bridged interface

2. installing Vagrant and libvirt plugins

3. adjusting the IP and MAC settings in **Vagrantfile** script and NGINX **your_domain.conf** file to match with local network settings

4. adding VM IP/hostname to router */etc/hosts* settings for convenience

5. *(optional for NGINX use case) adapting the hostable content*  

6. bringing the machine up exporting the VAGRANT_DEFAULT_PROVIDER=libvirt variable and `vagrant up`  
or  
`vagrant up --provider=libvirt `
