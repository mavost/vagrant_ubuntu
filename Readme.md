# Ubuntu Linux virtualized using Vagrant/libvirt
the project uses the following components:
- host system is an Ubuntu 20.04 LTS desktop

- virtual machine is deployed using Vagrant (v. 2.2.18) Infrastructure as Code system

- Vagrant uses the non-standard libvirt provider, i.e. QEMU/KVM hypervisor

- guest runs on an Ubuntu 20.04 LTS server box

There are three further provisioning options defined so far:
    
  1. a very basic NGINX (v.1.18) webserver setup  
  &rightarrow; sample website is fetched from a generic code repository using git hosted on a generic domain server block

  2. a basic docker installation using the **docker-ce** repository
  &rightarrow; testing an image pull from tutorial: *docker/getting-started:latest*

  3. a conventional LAMP stack deployment including Apache (v. 2.4.41), MySQL (v. 8.0.26) and PHP (v. 7.4.3)  
  &rightarrow; providing a testing database and for *component testing purposes* static **index.html**, **index.php**, sample website, and dynamic **shopping-list.php** hosted on a generic domain server block
  ## requirements on host
1. QEMU/KVM hypervisor with a bridged interface

2. installing Vagrant and libvirt plugins

3. adjusting the IP and MAC settings in **Vagrantfile** script and NGINX **your_domain.conf** file to match with local network settings

4. adding VM IP/hostname to router */etc/hosts* settings for convenience

5. *(optional for NGINX/LAMP use cases) adapting the hostable content*  

6. bringing the machine up exporting the VAGRANT_DEFAULT_PROVIDER=libvirt variable and `vagrant up`  
or  
`vagrant up --provider=libvirt `
