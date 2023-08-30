# My_Ansible_playbooks
Some of my Ansible playbooks I used


Setup custom package with APT or YUM
```bash
ansible-playbook  installation-playbooks/install_custom_package.yml -e package_name=vim
```

Add ssh key from github
```
ansible-playbook configuration-playbooks/manage_ssh_key.yml -e "state=present" -e "user=root" -e "github_account=mparvin"
```

Remove ssh key 
```
ansible-playbook configuration-playbooks/manage_ssh_key.yml -e "state=absent" -e "user=root" -e "github_account=mparvin"
```
