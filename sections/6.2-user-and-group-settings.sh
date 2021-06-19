# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 6.2 User and Group Settings
# --------------------------------------------

# 6.2.1 Ensure password fields are not empty (Scored)
log "CIS" "6.2.1 Ensure password fields are not empty (Scored)"
execute_command "for user in `cat /etc/shadow | awk -F: '($2 == \"\") {print $1}'`; do passwd -l \$user; done"

# 6.2.2 Ensure no legacy "+" entries exist in /etc/passwd (Scored)
log "CIS" "6.2.2 Ensure no legacy \"+\" entries exist in /etc/passwd (Scored)"
execute_command "sed -i '/^+/ d' /etc/passwd"

# 6.2.3 Ensure no legacy "+" entries exist in /etc/shadow (Scored)
log "CIS" "6.2.3 Ensure no legacy \"+\" entries exist in /etc/shadow (Scored)"
execute_command "sed -i '/^+/ d' /etc/shadow"

# 6.2.4 Ensure no legacy "+" entries exist in /etc/group (Scored)
log "CIS" "6.2.4 Ensure no legacy \"+\" entries exist in /etc/group (Scored)"
execute_command "sed -i '/^+/ d' /etc/group"

# 6.2.5 Ensure root is the only UID 0 account (Scored)
log "CIS" "6.2.5 Ensure root is the only UID 0 account (Scored)"
execute_command "for user in `cat /etc/passwd | awk -F: '($3==0 && $1!=\"root\") {print $1}'`; do passwd -l \$user ; done"

# 6.2.6 Ensure root PATH Integrity (Scored)
log "CIS" "6.2.6 Ensure root PATH Integrity (Scored)"
check_root_path_integrity

# 6.2.7 Ensure all users' home directories exist (Scored)
log "CIS" "6.2.7 Ensure all users' home directories exist (Scored)"
check_home_directries_exist

# 6.2.8 Ensure users' home directories permissions are 750 or more restrictive (Scored)
log "CIS" "6.2.8 Ensure users' home directories permissions are 750 or more restrictive (Scored)"
execute_command "egrep -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '(\$7!=\"/sbin/nologin\" && \$7!=\"/bin/false\") {print \$6}' | while read dir; do chmod 0750 \$dir; done"

# 6.2.9 Ensure users own their home directories (Scored)
log "CIS" "6.2.9 Ensure users own their home directories (Scored)"
execute_command "egrep -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '(\$7!=\"/sbin/nologin\" && \$7!=\"/bin/false\") {print \$1 \" \" \$6}' | while read user dir; do chown \${user}:\${user} \$dir; done"

# 6.2.10 Ensure users' dot files are not group or world writable (Scored)
log "CIS" "6.2.10 Ensure users' dot files are not group or world writable (Scored)"
execute_command "egrep -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '(\$7!=\"/sbin/nologin\" && \$7!=\"/bin/false\") {print \$6}' | while read dir; do find \$dir/ -type f -name '.*' | xargs --no-run-if-empty chmod og-w; done"

# 6.2.11 Ensure no users have .forward files (Scored)
log "CIS" "6.2.11 Ensure no users have .forward files (Scored)"
unwanted_files ".forward"

# 6.2.12 Ensure no users have .netrc files (Scored)
log "CIS" "6.2.12 Ensure no users have .netrc files (Scored)"
unwanted_files ".netrc"

# 6.2.13 Ensure users' .netrc Files are not group or world accessible (Scored)
log "CIS" "6.2.13 Ensure users' .netrc Files are not group or world accessible (Scored)"
execute_command "egrep -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '(\$7!=\"/sbin/nologin\" && \$7!=\"/bin/false\") {print \$6}' | while read dir; do if [ -d \$dir/.netrc ]; then find \$dir/.netrc -type f | xargs --no-run-if-empty chmod og-rwx; fi; done"

# 6.2.14 Ensure no users have .rhosts files (Scored)
log "CIS" "6.2.14 Ensure no users have .rhosts files (Scored)"
unwanted_files ".rhosts"

# 6.2.15 Ensure all groups in /etc/passwd exist in /etc/group (Scored)
log "CIS" "6.2.15 Ensure all groups in /etc/passwd exist in /etc/group (Scored)"
check_passwd_in_group

# 6.2.16 Ensure no duplicate UIDs exist (Scored)
log "CIS" "6.2.16 Ensure no duplicate UIDs exist (Scored)"
check_duplicate_uid

# 6.2.17 Ensure no duplicate GIDs exist (Scored)
log "CIS" "6.2.17 Ensure no duplicate GIDs exist (Scored)"
check_duplicate_gid

# 6.2.18 Ensure no duplicate user names exist (Scored)
log "CIS" "6.2.18 Ensure no duplicate user names exist (Scored)"
check_duplicate_user

# 6.2.19 Ensure no duplicate group names exist (Scored)
log "CIS" "6.2.19 Ensure no duplicate group names exist (Scored)"
check_duplicate_group
