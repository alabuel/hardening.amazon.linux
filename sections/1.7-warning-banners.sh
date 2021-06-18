# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 1.7 Warning Banners
# 1.7.1 Command Line Warning Banners
# --------------------------------------------

# 1.7.1.1 Ensure message of the day is configured properly (Scored)
log "CIS" "1.7.1.1 Ensure message of the day is configured properly (Scored)"
# execute_command "echo $MOTD_BANNER > /etc/motd"
execute_command "sed -i 's/\\v//g' /etc/motd"
execute_command "sed -i 's/\\r//g' /etc/motd"
execute_command "sed -i 's/\\m//g' /etc/motd"
execute_command "sed -i 's/\\s//g' /etc/motd"
execute_command "sed -i 's/Amazon//g' /etc/motd"

# 1.7.1.2 Ensure local login warning banner is configured properly (Not Scored)
log "CIS" "1.7.1.2 Ensure local login warning banner is configured properly (Not Scored)"
execute_command "echo $WARNING_BANNER > /etc/issue"
execute_command "sed -i 's/\\v//g' /etc/issue"
execute_command "sed -i 's/\\r//g' /etc/issue"
execute_command "sed -i 's/\\m//g' /etc/issue"
execute_command "sed -i 's/\\s//g' /etc/issue"
execute_command "sed -i 's/Amazon//g' /etc/issue"

# 1.7.1.3 Ensure remote login warning banner is configured properly (Not Scored)
log "CIS" "1.7.1.3 Ensure remote login warning banner is configured properly (Not Scored)"
execute_command "echo $WARNING_BANNER > /etc/issue.net"
execute_command "sed -i 's/\\v//g' /etc/issue.net"
execute_command "sed -i 's/\\r//g' /etc/issue.net"
execute_command "sed -i 's/\\m//g' /etc/issue.net"
execute_command "sed -i 's/\\s//g' /etc/issue.net"
execute_command "sed -i 's/Amazon//g' /etc/issue.net"

# 1.7.1.4 Ensure permissions on /etc/motd are configured (Not Scored)
log "CIS" "1.7.1.4 Ensure permissions on /etc/motd are configured (Not Scored)"
execute_command "chown root:root /etc/motd"
execute_command "chmod 644 /etc/motd"

# 1.7.1.5 Ensure permissions on /etc/issue are configured (Scored)
log "CIS" "1.7.1.5 Ensure permissions on /etc/issue are configured (Scored)"
execute_command "chown root:root /etc/issue"
execute_command "chmod 644 /etc/issue"

# 1.7.1.6 Ensure permissions on /etc/issue.net are configured (Not Scored)
log "CIS" "1.7.1.6 Ensure permissions on /etc/issue.net are configured (Not Scored)"
execute_command "chown root:root /etc/issue.net"
execute_command "chmod 644 /etc/issue.net"

# 1.8 Ensure updates, patches, and additional security software are installed (Scored)
log "CIS" "1.8 Ensure updates, patches, and additional security software are installed (Scored)"
execute_command "yum -y update --security"
