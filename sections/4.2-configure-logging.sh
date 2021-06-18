# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 4.2 Configure Logging
# 4.2.1 Configure rsyslog
# --------------------------------------------

# 4.2.1.1 Ensure rsyslog Service is enabled (Scored)
log "CIS" "4.2.1.1 Ensure rsyslog Service is enabled (Scored)"
if [ "$USE_RSYSLOG" == true ]; then
  service_enable "rsyslog"
else
  skip "rsyslog not in use"
fi

# 4.2.1.2 Ensure logging is configured (Not Scored)
log "CIS" "4.2.1.2 Ensure logging is configured (Not Scored)"
if [ "$USE_RSYSLOG" == true ]; then
  execute_command "cp templates/4.2.1.2-rsyslog.conf /etc/rsyslog.d/4.2.1.2-rsyslog.conf"
  execute_command "pkill -HUP rsyslogd"
else
  skip "rsyslog not in use"
fi

# 4.2.1.3 Ensure rsyslog default file permissions configured (Scored)
log "CIS" "4.2.1.3 Ensure rsyslog default file permissions configured (Scored)"
if [ "$USE_RSYSLOG" == true ]; then
  line_replace "/etc/rsyslog.conf" "^\$FileCreateMode" "\$FileCreateMode 0640"
else
  skip "rsyslog not in use"
fi

# 4.2.1.3 Ensure rsyslog default file permissions configured (Scored)
log "CIS" "4.2.1.3 Ensure rsyslog default file permissions configured (Scored)"
if [ "$USE_RSYSLOG" == true ] && [ "$CENTRAL_LOG_HOST" != "" ]; then
  line_replace "/etc/rsyslog.conf" "^\*\.\*" "*.* @@${CENTRAL_LOG_HOST}"
  execute_command "pkill -HUP rsyslogd"
else
  skip "need CENTRAL_LOG_HOST to send logs to a remote log host running syslogd"
fi

# 4.2.1.5 Ensure remote rsyslog messages are only accepted on designated log hosts. (Not Scored)
log "CIS" "4.2.1.5 Ensure remote rsyslog messages are only accepted on designated log hosts. (Not Scored)"
if [ "$USE_RSYSLOG" == true ]; then
  line_replace "/etc/rsyslog.conf" "^\$ModLoad" "#\$ModLoad imtcp"
  line_replace "/etc/rsyslog.conf" "^\$InputTCPServerRun" "#\$InputTCPServerRun 514"
  execute_command "pkill -HUP rsyslogd"
else
  skip "rsyslog not in use"
fi

# 4.2.2.1 Ensure syslog-ng service is enabled (Scored)
log "CIS" "4.2.2.1 Ensure syslog-ng service is enabled (Scored)"
if [ "$USE_SYSLOG_NG" == true ]; then
  service_enable "syslog-ng"
else
  skip "syslog-ng not in use"
fi

# 4.2.2.2 Ensure logging is configured (Not Scored)
log "CIS" "4.2.2.2 Ensure logging is configured (Not Scored)"
if [ "$USE_SYSLOG_NG" == true ]; then
  execute_command "cp templates/4.2.2.2-syslog-ng.conf /etc/rsyslog.d/4.2.2.2-syslog-ng.conf"
else
  skip "syslog-ng not in use"
fi

# 4.2.2.3 Ensure syslog-ng default file permissions configured (Scored)
log "CIS" "4.2.2.3 Ensure syslog-ng default file permissions configured (Scored)"
if [ "$USE_SYSLOG_NG" == true ]; then
  line_replace "/etc/syslog-ng/syslog-ng.conf" "^options" "options { chain_hostname(off); flush_lines(0); perm(0640); stats_freq(3600); threaded(yes); };"
else
  skip "syslog-ng not in use"
fi

# 4.2.2.4 Ensure syslog-ng is configured to send logs to a remote log host (Not Scored)
log "CIS" "4.2.2.4 Ensure syslog-ng is configured to send logs to a remote log host (Not Scored)"
if [ "$USE_SYSLOG_NG" == true ] && [ "$CENTRAL_LOG_HOST" != "" ]; then
  line_add "/etc/syslog-ng/syslog-ng.conf" "destination logserver { tcp(\"${CENTRAL_LOG_HOST}\" port(514)); };"
  line_add "/etc/syslog-ng/syslog-ng.conf" "log { source(src); destination(logserver); };"
  execute_command "pkill -HUP syslog-ng"
fi

# 4.2.2.5 Ensure remote syslog-ng messages are only accepted on designated log hosts (Not Scored)
log "CIS" "4.2.2.5 Ensure remote syslog-ng messages are only accepted on designated log hosts (Not Scored)"
skip "By default, syslog-ng does not listen for log messages coming in from remote systems."

# 4.2.3 Ensure rsyslog or syslog-ng is installed (Scored)
log "CIS" "4.2.3 Ensure rsyslog or syslog-ng is installed (Scored)"
if [ "$USE_RSYSLOG" == true ]; then
  package_install "rsyslog"
elif [ "$USE_SYSLOG_NG" == true ]; then
  package_install "syslog-ng"
fi

# 4.2.4 Ensure permissions on all logfiles are configured (Scored)
log "CIS" "4.2.4 Ensure permissions on all logfiles are configured (Scored)"
execute_command "find /var/log -type f -exec chmod g-wx,o-rwx {} +"

# 4.3 Ensure logrotate is configured (Not Scored)
log "CIS" "4.3 Ensure logrotate is configured (Not Scored)"
skip "Edit /etc/logrotate.conf and /etc/logrotate.d/* to ensure logs are rotated according to site policy."
