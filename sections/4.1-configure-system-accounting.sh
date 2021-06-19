# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 4 Logging and Auditing
# 4.1 Configure System Accounting (auditd)
# 4.1.1 Configure Data Retention
# --------------------------------------------

# 4.1.1.1 Ensure audit log storage size is configured (Not Scored)
log "CIS" "4.1.1.1 Ensure audit log storage size is configured (Not Scored)"
line_replace "/etc/audit/auditd.conf" "^max_log_file" "max_log_file = ${MAX_LOG_FILE}"

# 4.1.1.2 Ensure system is disabled when audit logs are full (Scored)
log "CIS" "4.1.1.2 Ensure system is disabled when audit logs are full (Scored)"
line_replace "/etc/audit/auditd.conf" "^space_left_action" "space_left_action = email"
line_replace "/etc/audit/auditd.conf" "^action_mail_acct" "action_mail_acct = root"
line_replace "/etc/audit/auditd.conf" "^admin_space_left_action" "admin_space_left_action = halt"

# 4.1.1.3 Ensure audit logs are not automatically deleted (Scored)
log "CIS" "4.1.1.3 Ensure audit logs are not automatically deleted (Scored)"
line_replace "/etc/audit/auditd.conf" "^max_log_file_action" "max_log_file_action = keep_logs"

# 4.1.2 Ensure auditd service is enabled (Scored)
log "CIS" "4.1.2 Ensure auditd service is enabled (Scored)"
service_enable "auditd"

# 4.1.3 Ensure auditing for processes that start prior to auditd is enabled (Scored)
log "CIS" "4.1.3 Ensure auditing for processes that start prior to auditd is enabled (Scored)"
grub_option "add" "GRUB_CMDLINE_LINUX" "audit=1"

# 4.1.4 Ensure events that modify date and time information are collected (Scored)
log "CIS" "4.1.4 Ensure events that modify date and time information are collected (Scored)"
if [ "$KERNEL" == "32" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time- change"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S clock_settime -k time-change"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/localtime -p wa -k time-change"
elif [ "$KERNEL" == "64" ]; then
  line_add "/etc/audit/audit.rules" "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change"
  line_add "/etc/audit/audit.rules" "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change"
  line_add "/etc/audit/audit.rules" "-a always,exit -F arch=b64 -S clock_settime -k time-change"
  line_add "/etc/audit/audit.rules" "-a always,exit -F arch=b32 -S clock_settime -k time-change"
  line_add "/etc/audit/audit.rules" "-w /etc/localtime -p wa -k time-change"
fi

# 4.1.5 Ensure events that modify user/group information are collected (Scored)
log "CIS" "4.1.5 Ensure events that modify user/group information are collected (Scored)"
line_add "/etc/audit/rules.d/audit.rules" "-w /etc/group -p wa -k identity"
line_add "/etc/audit/rules.d/audit.rules" "-w /etc/passwd -p wa -k identity"
line_add "/etc/audit/rules.d/audit.rules" "-w /etc/gshadow -p wa -k identity"
line_add "/etc/audit/rules.d/audit.rules" "-w /etc/shadow -p wa -k identity"
line_add "/etc/audit/rules.d/audit.rules" "-w /etc/security/opasswd -p wa -k identity"

# 4.1.6 Ensure events that modify the system's network environment are collected (Scored)
log "CIS" "4.1.6 Ensure events that modify the system's network environment are collected (Scored)"
if [ "$KERNEL" == "32" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/issue -p wa -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/issue.net -p wa -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/hosts -p wa -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/sysconfig/network -p wa -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/sysconfig/network-scripts/ -p wa -k system-locale"
elif [ "$KERNEL" == "64" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/issue -p wa -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/issue.net -p wa -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/hosts -p wa -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/sysconfig/network -p wa -k system-locale"
  line_add "/etc/audit/rules.d/audit.rules" "-w /etc/sysconfig/network-scripts/ -p wa -k system-locale"
fi

# 4.1.7 Ensure events that modify the system's Mandatory Access Controls are collected (Scored)
log "CIS" "4.1.7 Ensure events that modify the system's Mandatory Access Controls are collected (Scored)"
line_add "/etc/audit/rules.d/audit.rules" "-w /etc/selinux/ -p wa -k MAC-policy"
line_add "/etc/audit/rules.d/audit.rules" "-w /usr/share/selinux/ -p wa -k MAC-policy"

# 4.1.8 Ensure login and logout events are collected (Scored)
log "CIS" "4.1.8 Ensure login and logout events are collected (Scored)"
line_add "/etc/audit/rules.d/audit.rules" "-w /var/log/lastlog -p wa -k logins"
line_add "/etc/audit/rules.d/audit.rules" "-w /var/run/faillock/ -p wa -k logins"

# 4.1.9 Ensure session initiation information is collected (Scored)
log "CIS" "4.1.9 Ensure session initiation information is collected (Scored)"
line_add "/etc/audit/rules.d/audit.rules" "-w /var/run/utmp -p wa -k session"
line_add "/etc/audit/rules.d/audit.rules" "-w /var/log/wtmp -p wa -k logins"
line_add "/etc/audit/rules.d/audit.rules" "-w /var/log/btmp -p wa -k logins"

# 4.1.10 Ensure discretionary access control permission modification events are collected (Scored)
log "CIS" "4.1.10 Ensure discretionary access control permission modification events are collected (Scored)"
if [ "$KERNEL" == "32" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
elif [ "$KERNEL" == "64" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
fi

# 4.1.11 Ensure unsuccessful unauthorized file access attempts are collected (Scored)
log "CIS" "4.1.11 Ensure unsuccessful unauthorized file access attempts are collected (Scored)"
if [ "$KERNEL" == "32" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access"
elif [ "$KERNEL" == "64" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access"
fi

# 4.1.12 Ensure use of privileged commands is collected (Scored)
log "CIS" "4.1.12 Ensure use of privileged commands is collected (Scored)"
execute_command "find / -xdev \\( -perm -4000 -o -perm -2000 \\) -type f | awk '{print \"-a always,exit -F path=\" $1 \" -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged\"}' >> /etc/audit/audit.rules"

# 4.1.13 Ensure successful file system mounts are collected (Scored)
log "CIS" "4.1.13 Ensure successful file system mounts are collected (Scored)"
if [ "$KERNEL" == "32" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts"
elif [ "$KERNEL" == "64" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts"
fi

# 4.1.14 Ensure file deletion events by users are collected (Scored)
log "CIS" "4.1.14 Ensure file deletion events by users are collected (Scored)"
if [ "$KERNEL" == "32" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete"
elif [ "$KERNEL" == "64" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete"
fi

# 4.1.15 Ensure changes to system administration scope (sudoers) is collected (Scored)
log "CIS" "4.1.15 Ensure changes to system administration scope (sudoers) is collected (Scored)"
line_add "/etc/audit/rules.d/audit.rules" "-w /etc/sudoers -p wa -k scope"
line_add "/etc/audit/rules.d/audit.rules" "-w /etc/sudoers.d/ -p wa -k scope"

# 4.1.16 Ensure system administrator actions (sudolog) are collected (Scored)
log "CIS" "4.1.16 Ensure system administrator actions (sudolog) are collected (Scored)"
line_add "/etc/audit/rules.d/audit.rules" "-w /var/log/sudo.log -p wa -k actions"

# 4.1.17 Ensure kernel module loading and unloading is collected (Scored)
log "CIS" "4.1.17 Ensure kernel module loading and unloading is collected (Scored)"
if [ "$KERNEL" == "32" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-w /sbin/insmod -p x -k modules"
  line_add "/etc/audit/rules.d/audit.rules" "-w /sbin/rmmod -p x -k modules"
  line_add "/etc/audit/rules.d/audit.rules" "-w /sbin/modprobe -p x -k modules"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b32 -S init_module -S delete_module -k modules"
elif [ "$KERNEL" == "64" ]; then
  line_add "/etc/audit/rules.d/audit.rules" "-w /sbin/insmod -p x -k modules"
  line_add "/etc/audit/rules.d/audit.rules" "-w /sbin/rmmod -p x -k modules"
  line_add "/etc/audit/rules.d/audit.rules" "-w /sbin/modprobe -p x -k modules"
  line_add "/etc/audit/rules.d/audit.rules" "-a always,exit -F arch=b64 -S init_module -S delete_module -k modules"
fi

# 4.1.18 Ensure the audit configuration is immutable (Scored)
log "CIS" "4.1.18 Ensure the audit configuration is immutable (Scored)"
line_add "/etc/audit/rules.d/audit.rules" "-e 2"
