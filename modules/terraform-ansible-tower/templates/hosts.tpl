[tower]
%{ for tower in tower_hosts_def ~}
${tower}
%{ endfor ~}