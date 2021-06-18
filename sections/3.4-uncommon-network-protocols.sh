# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 3.4 Uncommon Network Protocols
# --------------------------------------------

# 3.4.1 Ensure DCCP is disabled (Not Scored)
log "CIS" "3.4.1 Ensure DCCP is disabled (Not Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install dccp" "install dccp /bin/true"

# 3.4.2 Ensure SCTP is disabled (Not Scored)
log "CIS" "3.4.2 Ensure SCTP is disabled (Not Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install sctp" "install sctp /bin/true"

# 3.4.3 Ensure RDS is disabled (Not Scored)
log "CIS" "3.4.3 Ensure RDS is disabled (Not Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install rds" "install rds /bin/true"

# 3.4.4 Ensure TIPC is disabled (Not Scored)
log "CIS" "3.4.4 Ensure TIPC is disabled (Not Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install tipc" "install tipc /bin/true"
