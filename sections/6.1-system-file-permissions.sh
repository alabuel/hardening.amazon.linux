# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 6 System Maintenance
# 6.1 System File Permissions
# --------------------------------------------

# 6.1.1 Audit system file permissions (Not Scored)
log "CIS" "6.1.1 Audit system file permissions (Not Scored)"
execute_command "rpm -Va --nomtime --nosize --nomd5 --nolinkto > packages.audit"
skip "review all installed packages from packages.audit file"

# 6.1.2 Ensure permissions on /etc/passwd are configured (Scored)
log "CIS" "6.1.2 Ensure permissions on /etc/passwd are configured (Scored)"
execute_command "chown root:root /etc/passwd"
execute_command "chmod 644 /etc/passwd"

# 6.1.3 Ensure permissions on /etc/shadow are configured (Scored)
log "CIS" "6.1.3 Ensure permissions on /etc/shadow are configured (Scored)"
execute_command "chown root:root /etc/shadow"
execute_command "chmod 000 /etc/shadow"

# 6.1.4 Ensure permissions on /etc/group are configured (Scored)
log "CIS" "6.1.4 Ensure permissions on /etc/group are configured (Scored)"
execute_command "chown root:root /etc/group"
execute_command "chmod 644 /etc/group"

# 6.1.5 Ensure permissions on /etc/gshadow are configured (Scored)
log "CIS" "6.1.5 Ensure permissions on /etc/gshadow are configured (Scored)"
execute_command "chown root:root /etc/gshadow"
execute_command "chmod 000 /etc/gshadow"

# 6.1.6 Ensure permissions on /etc/passwd- are configured (Scored)
log "CIS" "6.1.6 Ensure permissions on /etc/passwd- are configured (Scored)"
execute_command "chown root:root /etc/passwd-"
execute_command "chmod u-x,go-wx /etc/passwd-"

# 6.1.7 Ensure permissions on /etc/shadow- are configured (Scored)
log "CIS" "6.1.7 Ensure permissions on /etc/shadow- are configured (Scored)"
execute_command "chown root:root /etc/shadow-"
execute_command "chmod 000 /etc/shadow-"

# 6.1.8 Ensure permissions on /etc/group- are configured (Scored)
log "CIS" "6.1.8 Ensure permissions on /etc/group- are configured (Scored)"
execute_command "chown root:root /etc/group-"
execute_command "chmod u-x,go-wx /etc/group-"

# 6.1.9 Ensure permissions on /etc/gshadow- are configured (Scored)
log "CIS" "6.1.9 Ensure permissions on /etc/gshadow- are configured (Scored)"
execute_command "chown root:root /etc/gshadow-"
execute_command "chmod 000 /etc/gshadow-"

# 6.1.10 Ensure no world writable files exist (Scored)
log "CIS" "6.1.10 Ensure no world writable files exist (Scored)"
execute_command "df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -0002 | xargs -I '{}' chmod o-w '{}'"

# 6.1.11 Ensure no unowned files or directories exist (Scored)
log "CIS" "6.1.11 Ensure no unowned files or directories exist (Scored)"
execute_command "df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser | xargs -I '{}' chown root:root '{}'"

# 6.1.12 Ensure no ungrouped files or directories exist (Scored)
log "CIS" "6.1.12 Ensure no ungrouped files or directories exist (Scored)"
execute_command "df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nogroup | xargs -I '{}' chgrp root '{}'"

# 6.1.13 Audit SUID executables (Not Scored)
log "CIS" "6.1.13 Audit SUID executables (Not Scored)"
execute_command "df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000"
skip "Ensure that no rogue SUID programs have been introduced into the system. Review the files returned by the action in the Audit section and confirm the integrity of these binaries."

# 6.1.14 Audit SGID executables (Not Scored)
log "CIS" "6.1.14 Audit SGID executables (Not Scored)"
execute_command "df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -2000"
skip "Ensure that no rogue SGID programs have been introduced into the system. Review the files returned by the action in the Audit section and confirm the integrity of these binaries."




