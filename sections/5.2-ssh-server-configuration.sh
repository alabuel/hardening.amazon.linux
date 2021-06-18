# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 5.2 SSH Server Configuration
# --------------------------------------------

# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured (Scored)
log "CIS" "5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured (Scored)"
execute_command "chown root:root /etc/ssh/sshd_config"
execute_command "chmod og-rwx /etc/ssh/sshd_config"

# 5.2.2 Ensure permissions on SSH private host key files are configured (Scored)
log "CIS" "5.2.2 Ensure permissions on SSH private host key files are configured (Scored)"
execute_command "find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:ssh_keys {} \\;"
execute_command "find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 0640 {} \\;"

# 5.2.3 Ensure permissions on SSH public host key files are configured (Scored)
log "CIS" "5.2.3 Ensure permissions on SSH public host key files are configured (Scored)"
execute_command "find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod 0644 {} \\;"
execute_command "find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \\;"

# 5.2.4 Ensure SSH Protocol is set to 2 (Scored)
log "CIS" "5.2.4 Ensure SSH Protocol is set to 2 (Scored)"
line_replace "/etc/ssh/sshd_config" "^Protocol" "Protocol 2"

# 5.2.5 Ensure SSH LogLevel is appropriate (Scored)
log "CIS" "5.2.5 Ensure SSH LogLevel is appropriate (Scored)"
line_replace "/etc/ssh/sshd_config" "^LogLevel" "LogLevel ${LOG_LEVEL}"

# 5.2.6 Ensure SSH X11 forwarding is disabled (Scored)
log "CIS" "5.2.6 Ensure SSH X11 forwarding is disabled (Scored)"
line_replace "/etc/ssh/sshd_config" "^X11Forwarding" "X11Forwarding no"

# 5.2.7 Ensure SSH MaxAuthTries is set to 4 or less (Scored)
log "CIS" "5.2.7 Ensure SSH MaxAuthTries is set to 4 or less (Scored)"
line_replace "/etc/ssh/sshd_config" "^MaxAuthTries" "MaxAuthTries ${SSH_MAX_AUTH_TRIES}"

# 5.2.8 Ensure SSH IgnoreRhosts is enabled (Scored)
log "CIS" "5.2.8 Ensure SSH IgnoreRhosts is enabled (Scored)"
line_replace "/etc/ssh/sshd_config" "^IgnoreRhosts" "IgnoreRhosts ${SSH_IGNORE_RHOSTS}"

# 5.2.9 Ensure SSH HostbasedAuthentication is disabled (Scored)
log "CIS" "5.2.9 Ensure SSH HostbasedAuthentication is disabled (Scored)"
line_replace "/etc/ssh/sshd_config" "^HostbasedAuthentication" "HostbasedAuthentication ${SSH_HOST_BASED_AUTHENTICATION}"

# 5.2.10 Ensure SSH root login is disabled (Scored)
log "CIS" "5.2.10 Ensure SSH root login is disabled (Scored)"
line_replace "/etc/ssh/sshd_config" "^PermitRootLogin" "PermitRootLogin ${SSH_PERMIT_ROOT_LOGIN}"

# 5.2.11 Ensure SSH PermitEmptyPasswords is disabled (Scored)
log "CIS" "5.2.11 Ensure SSH PermitEmptyPasswords is disabled (Scored)"
line_replace "/etc/ssh/sshd_config" "^PermitEmptyPasswords ${SSH_PERMIT_EMPTY_PASSWORDS}"

# 5.2.12 Ensure SSH PermitUserEnvironment is disabled (Scored)
log "CIS" "5.2.12 Ensure SSH PermitUserEnvironment is disabled (Scored)"
line_replace "/etc/ssh/sshd_config" "^PermitUserEnvironment ${SSH_PERMIT_USER_ENVIRONMENT}"

# 5.2.13 Ensure only strong ciphers are used (Scored)
log "CIS" "5.2.13 Ensure only strong ciphers are used (Scored)"
line_replace "/etc/ssh/sshd_config" "^Ciphers " "Ciphers ${SSH_STRONG_CIPHERS}"

# 5.2.14 Ensure only strong MAC algorithms are used (Scored)
log "CIS" "5.2.14 Ensure only strong MAC algorithms are used (Scored)"
line_replace "/etc/ssh/sshd_config" "^MACs " "MACs ${SSH_STRONG_MACS}"

# 5.2.15 Ensure that strong Key Exchange algorithms are used (Scored)
log "CIS" "5.2.15 Ensure that strong Key Exchange algorithms are used (Scored)"
line_replace "/etc/ssh/sshd_config" "^KexAlgorithms " "KexAlgorithms ${SSH_STRONG_KEX_ALGORITHMS}"

# 5.2.16 Ensure SSH Idle Timeout Interval is configured (Scored)
log "CIS" "5.2.16 Ensure SSH Idle Timeout Interval is configured (Scored)"
line_replace "/etc/ssh/sshd_config" "^ClientAliveInterval 300"
line_replace "/etc/ssh/sshd_config" "^ClientAliveCountMax 0"

# 5.2.17 Ensure SSH LoginGraceTime is set to one minute or less (Scored)
log "CIS" "5.2.17 Ensure SSH LoginGraceTime is set to one minute or less (Scored)"
line_replace "/etc/ssh/sshd_config" "^LoginGraceTime ${SSH_LOGIN_GRACE_TIME}"

# 5.2.18 Ensure SSH access is limited (Scored)
log "CIS" "5.2.18 Ensure SSH access is limited (Scored)"
[[ "$SSH_ALLOW_USERS" != "" ]] && line_replace "/etc/ssh/sshd_config" "^AllowUsers" "AllowUsers ${SSH_ALLOW_USERS}"
[[ "$SSH_ALLOW_GROUPS" != "" ]] && line_replace "/etc/ssh/sshd_config" "^AllowGroups" "AllowGroups ${SSH_ALLOW_GROUPS}"
[[ "$SSH_DENY_USERS" != "" ]] && line_replace "/etc/ssh/sshd_config" "^DenyUsers" "DenyUsers ${SSH_DENY_USERS}"
[[ "$SSH_DENY_GROUPS" != "" ]] && line_replace "/etc/ssh/sshd_config" "^DenyGroups" "DenyGroups ${SSH_DENY_GROUPS}"

# 5.2.19 Ensure SSH warning banner is configured (Scored)
log "CIS" "5.2.19 Ensure SSH warning banner is configured (Scored)"
line_replace "/etc/ssh/sshd_config" "^Banner" "Banner /etc/issue.net"
