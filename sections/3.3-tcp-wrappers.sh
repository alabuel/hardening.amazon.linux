# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 3.3 TCP Wrappers
# --------------------------------------------

# 3.3.1 Ensure TCP Wrappers is installed (Scored)
log "CIS" "3.3.1 Ensure TCP Wrappers is installed (Scored)"
package_install "tcp_wrappers"

# 3.3.2 Ensure /etc/hosts.allow is configured (Not Scored)
log "CIS" "3.3.2 Ensure /etc/hosts.allow is configured (Not Scored)"
if [ "$ALLOWED_HOSTS" != "" ]; then
  line_replace "/etc/hosts.allow" "^ALL:" "ALL: ${ALLOWED_HOSTS}"
else
  skip "need list of allowed hosts"
fi

# 3.3.3 Ensure /etc/hosts.deny is configured (Not Scored)
log "CIS" "3.3.3 Ensure /etc/hosts.deny is configured (Not Scored)"
if [ "$ALLOWED_HOSTS" != "" ]; then
  line_replace "/etc/hosts.deny" "^ALL:" "ALL: ALL"
else
  skip "need first the list of allowed hosts. if no allowed hosts, no one can access the host"
fi

# 3.3.4 Ensure permissions on /etc/hosts.allow are configured (Scored)
log "CIS" "3.3.4 Ensure permissions on /etc/hosts.allow are configured (Scored)"
execute_command "chown root:root /etc/hosts.allow"
execute_command "chmod 644 /etc/hosts.allow"

# 3.3.5 Ensure permissions on /etc/hosts.deny are configured (Scored)
log "CIS" "3.3.5 Ensure permissions on /etc/hosts.deny are configured (Scored)"
execute_command "chown root:root /etc/hosts.deny"
execute_command "chmod 644 /etc/hosts.deny"
