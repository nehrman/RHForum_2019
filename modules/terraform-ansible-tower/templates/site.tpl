- name: Setup Ansible Tower Cluster
  hosts: tower
  any_errors_fatal: true
  become: true

  tasks:
    - name: Installed Pre Reqs Packages
      yum:
        name: 
          - ansible 
      state: "present"

    - name: Download Ansible Tower 
      unarchive: 
        src:
        dest:
        creates: 
        remote_src: true
    
    - name: import Ansible Tower Configuration
      copy: 
        src: 
        dest: 
        force: yes
    
    - name: Setup Ansible Tower 
      shell: "./setup.sh"
      args:
        chdir: 


