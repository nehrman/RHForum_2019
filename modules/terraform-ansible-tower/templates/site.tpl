- name: Setup Ansible Tower Cluster
  hosts: tower
  any_errors_fatal: true

  tasks:

    - name: Ensure ssh key is present
      copy:
        src: "./.ssh/id_rsa"
        dest: "/root/.ssh/"
        force: yes
        mode: '0400'
      become: true
    
    - name: Ensure ansible.cfg file is present
      copy:
        src: "./.ansible.cfg"
        dest: "/root/"
        force: yes
      become: true

    - name: Enabled Yum Repos
      raw: "sudo yum-config-manager --enable rhui-REGION-rhel-server-extras"
      become: true

    - name: Installed Pre Reqs Packages
      yum:
        name: 
          - ansible 
        state: "present"
      become: true

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
        dest: "${setup_dir}/ansible-tower-setup-bundle-${setup_version}/inventory"
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
      become: true
      run_once: yes

    - name: Waiting for Ansible Tower to become available
      uri:
        url: "https://${ tower_host_name }/api/v2/ping"
        validate_certs: "${tower_verify_ssl}"
        status_code: "200"
      register: result
      until: result.status == 200
      retries: 60
      delay: 1

    - name: Adding License fo Ansible Tower
      uri:
        url: "https://${ tower_host_name }/api/v2/config/"
        user: "${tower_setup_admin_user}"
        password: "${tower_setup_admin_password}"
        validate_certs: "${tower_verify_ssl}"
        force_basic_auth: true
        headers:
          Content-Type: "application/json"
          Accept: "application/json"
        method: POST
        body: '${tower_license}'
        body_format: "${tower_body_format}"


