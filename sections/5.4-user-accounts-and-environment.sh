# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 5.4 User Accounts and Environment
# 5.4.1 Set Shadow Password Suite Parameters
# --------------------------------------------

# 5.4.1.1 Ensure password expiration is 365 days or less (Scored)
log "CIS" "5.4.1.1 Ensure password expiration is 365 days or less (Scored)"
line_replace "/etc/login.defs" "^PASS_MAX_DAYS" "PASS_MAX_DAYS ${PASS_MAX_DAYS}"
while IFS=":" read -a user
do
  found=$(echo $EXCLUDE_USERS | grep ${user[0]})
  if [ -z "$found" ] && [ ! -z "${user[1]}" ]; then
    execute_command "chage --maxdays ${PASS_MAX_DAYS} ${user[0]}"
  fi
done < /etc/shadow

# 5.4.1.2 Ensure minimum days between password changes is 7 or more (Scored)
log "CIS" "5.4.1.2 Ensure minimum days between password changes is 7 or more (Scored)"
line_replace "/etc/login.defs" "^PASS_MIN_DAYS" "PASS_MIN_DAYS ${PASS_MIN_DAYS}"
while IFS=":" read -a user
do
  found=$(echo $EXCLUDE_USERS | grep ${user[0]})
  if [ -z "$found" ] && [ ! -z "${user[1]}" ]; then
    execute_command "chage --mindays ${PASS_MIN_DAYS} ${user[0]}"
  fi
done < /etc/shadow

# 5.4.1.3 Ensure password expiration warning days is 7 or more (Scored)
log "CIS" "5.4.1.3 Ensure password expiration warning days is 7 or more (Scored)"
line_replace "/etc/login.defs" "^PASS_WARN_AGE" "PASS_WARN_AGE ${PASS_WARN_AGE}"
while IFS=":" read -a user
do
  found=$(echo $EXCLUDE_USERS | grep ${user[0]})
  if [ -z "$found" ] && [ ! -z "${user[1]}" ]; then
    execute_command "chage --warndays ${PASS_WARN_AGE} ${user[0]}"
  fi
done < /etc/shadow

# 5.4.1.4 Ensure inactive password lock is 30 days or less (Scored)
log "CIS" "5.4.1.4 Ensure inactive password lock is 30 days or less (Scored)"
execute_command "useradd -D -f 30"
while IFS=":" read -a user
do
  found=$(echo $EXCLUDE_USERS | grep ${user[0]})
  if [ -z "$found" ] && [ ! -z "${user[1]}" ]; then
    execute_command "chage --inactive ${PASS_INACTIVE_LOCK_DAYS} ${user[0]}"
  fi
done < /etc/shadow

# 5.4.1.5 Ensure all users last password change date is in the past (Scored)
log "CIS" "5.4.1.5 Ensure all users last password change date is in the past (Scored)"
while IFS=":" read -a user
do
  found=$(echo $EXCLUDE_USERS | grep ${user[0]})
  if [ -z "$found" ] && [ ! -z "${user[1]}" ]; then
    execute_command "chage --list ${user[0]} | grep \"Last password change\""
  fi
done < /etc/shadow

# 5.4.2 Ensure system accounts are non-login (Scored)
log "CIS" "5.4.2 Ensure system accounts are non-login (Scored)"
set_all_user_shells "$EXCLUDE_USERS"

# 5.4.3 Ensure default group for the root account is GID 0 (Scored)
log "CIS" "5.4.3 Ensure default group for the root account is GID 0 (Scored)"
execute_command "usermod -g 0 root"

# 5.4.4 Ensure default user umask is 027 or more restrictive (Scored)
log "CIS" "5.4.4 Ensure default user umask is 027 or more restrictive (Scored)"
line_replace "/etc/bashrc" "^umask" "umask 027"
line_replace "/etc/profile" "^umask" "umask 027"
for FILE in /etc/profile.d/*.sh; do
  line_replace "$FILE" "^umask" "umask 027"
done

# 5.4.5 Ensure default user shell timeout is 900 seconds or less (Scored)
log "CIS" "5.4.5 Ensure default user shell timeout is 900 seconds or less (Scored)"
line_replace "/etc/bashrc" "^TMOUT=" "TMOUT=600"
line_replace "/etc/profile" "^TMOUT=" "TMOUT=600"

# 5.5 Ensure root login is restricted to system console (Not Scored)
log "CIS" "5.5 Ensure root login is restricted to system console (Not Scored)"
skip "Remove entries in /etc/securetty for any consoles that are not in a physically secure location."

# 5.6 Ensure access to the su command is restricted (Scored)
log "CIS" "5.6 Ensure access to the su command is restricted (Scored)"
line_replace "/etc/pam.d/su" "^auth required pam_wheel.so" "auth required pam_wheel.so use_uid"
line_add "/etc/group" "wheel:x:10:${SU_USER_LIST}"

