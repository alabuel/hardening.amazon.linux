# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 1.3 Filesystem Integrity Checking
# --------------------------------------------

# 1.3.1 Ensure AIDE is installed (Scored)
log "CIS" "1.3.1 Ensure AIDE is installed (Scored)"
execute_command "yum -y install aide"
execute_command "aide --init"
execute_command "mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz"

# 1.3.2 Ensure filesystem integrity is regularly checked (Scored)
log "CIS" "1.3.2 Ensure filesystem integrity is regularly checked (Scored)"
execute_command "crontab -l > mycron"
execute_command "echo '0 5 * * * /usr/sbin/aide --check' >> mycron"
execute_command "crontab mycron"
execute_command "rm -rf mycron"
