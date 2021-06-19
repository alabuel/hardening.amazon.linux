# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 5 Access, Authentication and Authorization
# 5.1 Configure cron
# --------------------------------------------

# 5.1.1 Ensure cron daemon is enabled (Scored)
log "CIS" "5.1.1 Ensure cron daemon is enabled (Scored)"
service_enable "crond"

# 5.1.2 Ensure permissions on /etc/crontab are configured (Scored)
log "CIS" "5.1.2 Ensure permissions on /etc/crontab are configured (Scored)"
execute_command "chown root:root /etc/crontab"
execute_command "chmod og-rwx /etc/crontab"

# 5.1.3 Ensure permissions on /etc/cron.hourly are configured (Scored)
log "CIS" "5.1.3 Ensure permissions on /etc/cron.hourly are configured (Scored)"
execute_command "chown root:root /etc/cron.hourly"
execute_command "chmod og-rwx /etc/cron.hourly"

# 5.1.4 Ensure permissions on /etc/cron.daily are configured (Scored)
log "CIS" "5.1.4 Ensure permissions on /etc/cron.daily are configured (Scored)"
execute_command "chown root:root /etc/cron.daily"
execute_command "chown root:root /etc/cron.daily"

# 5.1.5 Ensure permissions on /etc/cron.weekly are configured (Scored)
execute_command "chown root:root /etc/cron.weekly"
execute_command "chmod og-rwx /etc/cron.weekly"

# 5.1.6 Ensure permissions on /etc/cron.monthly are configured (Scored)
log "CIS" "5.1.6 Ensure permissions on /etc/cron.monthly are configured (Scored)"
execute_command "chown root:root /etc/cron.monthly"
execute_command "chmod og-rwx /etc/cron.monthly"

# 5.1.7 Ensure permissions on /etc/cron.d are configured (Scored)
log "CIS" "5.1.7 Ensure permissions on /etc/cron.d are configured (Scored)"
execute_command "chown root:root /etc/cron.d"
execute_command "chmod og-rwx /etc/cron.d"

# 5.1.8 Ensure at/cron is restricted to authorized users (Scored)
log "CIS" "5.1.8 Ensure at/cron is restricted to authorized users (Scored)"
[ -f "/etc/cron.deny" ] && execute_command "rm /etc/cron.deny"
[ -f "/etc/at.deny" ] && execute_command "rm /etc/at.deny"
execute_command "touch /etc/cron.allow"
execute_command "touch /etc/at.allow"
execute_command "chmod og-rwx /etc/cron.allow"
execute_command "chmod og-rwx /etc/at.allow"
execute_command "chown root:root /etc/cron.allow"
execute_command "chown root:root /etc/at.allow"
