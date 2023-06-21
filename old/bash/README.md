# Dastyar
Collection of bash scripts for repetitive tasks

### Run on Remote server

To run on remote server use the followin syntax:

```ssh root@SERVER_IP_OR_HOSTNAME "bash -s" < ./SCRIPT_NAME```

E.g:

```ssh root@192.168.1.100 "bash -s" < ./Install_node_exporter.sh```

For debug use '-x' option, e.g:

```ssh root@192.168.1.100 "bash -sx" < ./Install_node_exporter.sh```

# TODO
* create a script (Install_dependencies.sh) for install all dependencies on server like netstat and vim, In first section we must to check distributions
