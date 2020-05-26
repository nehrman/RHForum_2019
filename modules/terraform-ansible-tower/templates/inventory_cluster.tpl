[tower]
%{ for tower in tower_hosts_def ~}
${tower}
%{ endfor ~}

[isolated_group_isolated]
%{ for isolated in isolated_hosts_def ~}
${isolated}
%{ endfor ~}

[isolated_group_isolated]
controller=tower

[database]
%{ for postgresql in postgresql_hosts_def ~}
${postgresql}
%{ endfor ~}

[all:vars]
admin_password='${tower_setup_admin_password}'

pg_host='${postgresql_hosts_def}'
pg_port='${postgresql_port}'

pg_database='${tower_setup_pg_database}'
pg_username='${tower_setup_pg_username}'
pg_password='${tower_setup_pg_password}'

rabbitmq_port=5672
rabbitmq_vhost=tower
rabbitmq_username=tower
rabbitmq_password='${tower_setup_rabbitmq_pass}'
rabbitmq_cookie=cookiemonster

# Needs to be true for fqdns and ip addresses
rabbitmq_use_long_name=true