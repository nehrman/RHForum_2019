- name: Setup Ansible Tower Cluster
  hosts: tower
  any_errors_fatal: true
  become: true

  tasks:
    - name: Enabled Yum Repos
      raw: "sudo yum-config-manager --enable rhui-REGION-rhel-server-extras"

    - name: Installed Pre Reqs Packages
      yum:
        name: 
          - ansible 
      state: "present"

    - name: Download Ansible Tower 
      unarchive: 
        src: "https://releases.ansible.com/ansible-tower/setup-bundle/ansible-tower-setup-bundle-${setup_version}.tar.gz"
        dest: "${setup_dir}"
        creates: "${setup_dir}/ansible-tower-setup-bundle-${setup_version}"
        remote_src: true
      run_once: yes
    
    - name: import Ansible Tower Configuration
      copy: 
        src: "./inventory"
        dest: "${setup_dir }/ansible-tower-setup-bundle-${setup_version}/inventory"
        force: yes
      run_once: yes
    
    - name: Patch Ansible Tower Roles to make it work on AWS EC2 with rhui
      lineinfile: 
        dest: "${setup_dir }/ansible-tower-setup-bundle-${setup_version}/roles/repos_el/vars/RedHat-7.yml"
        state: present
        regexp: '^    - rhui-REGION-rhel-server-rhscl'
        line: '    - rhel-server-rhui-rhscl-7-rpms'
      run_once: yes
    
    - name: Setup Ansible Tower 
      shell: "./setup.sh"
      args:
        chdir: "${setup_dir}/ansible-tower-setup-bundle-${setup_version}"
      run_once: yes


