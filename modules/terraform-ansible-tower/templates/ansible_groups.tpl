[tower]
${tower_hosts_def}

[instances_group_isolated]
${isolated_hosts_def}

[database]

[all:vars]
admin_password='${tower_setup_admin_password}'

pg_host=''
pg_port=''

pg_database='${tower_setup_pg_database}'
pg_username='${tower_setup_pg_username}'
pg_password='${tower_setup_pg_password}'

rabbitmq_port=5672
rabbitmq_vhost=tower
rabbitmq_username=tower
rabbitmq_password='${tower_setup_rabbitmq_pass}'
rabbitmq_cookie=cookiemonster

# Needs to be true for fqdns and ip addresses
rabbitmq_use_long_name=false