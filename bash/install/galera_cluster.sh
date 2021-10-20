#!/bin/bash

galera_hosts_file=./.galera_servers
# Check ansible is installed
which ansible-playbook  || ( echo "You need ansible installed" && exit 1 )
# Check for galera data
[ -s ./galera_servers.list ] || \
echo -e '* read more about bootstraping here\n* https://mariadb.com/kb/en/getting-started-with-mariadb-galera-cluster/#bootstrapping-a-new-cluster'
# If data is not already exists, create an new file and get data from user
read -p "Enter galera bootstrap server" bootstrap_node && \
read -rep $'Enter other nodes, and seperate them with a comma\n for example\n 192.168.1.10, 192.168.1.11, 192.168.1.12, 192.168.1.13\n' nodes_addresses && \
read -p "Enter ssh user(attention: this user must has sudo privileges): " ssh_user
# Filling hosts file
echo "[galera]" > $galera_hosts_file && \
echo "galera_bootstrap ansible_host=$bootstrap_node ansible_user=$ansible_user" >> $galera_hosts_file && \
node_counter=1
for node_address in $(echo $nodes_addresses | sed "s/,/ /g")
do
echo "galera_node_$node_counter ansible_host=$node_address ansible_user=$ansible_user" >> $galera_hosts_file
node_counter=$((node_counter+1))
done
# Run ansible playbook
curl -sSL https://raw.githubusercontent.com/MParvin/Dastyar/master/ansible/installation-playbooks/galera_bootstrap.yml -o /tmp/galera_bootstrap.yml
ansible-playbook \
    -i $galera_hosts_file \
    -e 'host_name=galera_bootstrap'\
    -e "bootstrap_node=$bootstrap_node" \
    # playbook_action: bootstrap=start bootstrap command, add_node=add new node to master node
    -e "playbook_action=bootstrap"
    -e "nodes_addresses=$nodes_addresses" /tmp/galera_bootstrap.yml

curl -sSL https://raw.githubusercontent.com/MParvin/Dastyar/master/ansible/installation-playbooks/galera_nodes_install.yml -o /tmp/galera_nodes_install.yml
ansible-playbook -i $galera_hosts_file -e 'host_name=galera_bootstrap' /tmp/galera_bootstrap.yml
