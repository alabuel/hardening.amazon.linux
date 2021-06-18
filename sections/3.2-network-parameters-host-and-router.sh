# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 3.2 Network Parameters (Host and Router)
# --------------------------------------------

# 3.2.1 Ensure source routed packets are not accepted (Scored)
log "CIS" "3.2.1 Ensure source routed packets are not accepted (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.all.accept_source_route" "net.ipv4.conf.all.accept_source_route = 0"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.default.accept_source_route" "net.ipv4.conf.default.accept_source_route = 0"
line_replace "/etc/sysctl.conf" "^net.ipv6.conf.all.accept_source_route" "net.ipv6.conf.all.accept_source_route = 0"
line_replace "/etc/sysctl.conf" "^ipv6.conf.default.accept_source_route" "ipv6.conf.default.accept_source_route = 0"
execute_command "sysctl -w net.ipv4.conf.all.accept_source_route=0"
execute_command "sysctl -w net.ipv4.conf.default.accept_source_route=0"
execute_command "sysctl -w net.ipv6.conf.all.accept_source_route=0"
execute_command "sysctl -w net.ipv6.conf.default.accept_source_route=0"
execute_command "sysctl -w net.ipv4.route.flush=1"
execute_command "sysctl -w net.ipv6.route.flush=1"

# 3.2.2 Ensure ICMP redirects are not accepted (Scored)
log "CIS" "3.2.2 Ensure ICMP redirects are not accepted (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.all.accept_redirects" "net.ipv4.conf.all.accept_redirects = 0"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.default.accept_redirects" "net.ipv4.conf.default.accept_redirects = 0"
line_replace "/etc/sysctl.conf" "^net.ipv6.conf.all.accept_redirects" "net.ipv6.conf.all.accept_redirects = 0"
line_replace "/etc/sysctl.conf" "^net.ipv6.conf.default.accept_redirects" "net.ipv6.conf.default.accept_redirects = 0"
execute_command "sysctl -w net.ipv4.conf.all.accept_redirects=0"
execute_command "sysctl -w net.ipv4.conf.default.accept_redirects=0"
execute_command "sysctl -w net.ipv6.conf.all.accept_redirects=0"
execute_command "sysctl -w net.ipv6.conf.default.accept_redirects=0"
execute_command "sysctl -w net.ipv4.route.flush=1"
execute_command "sysctl -w net.ipv6.route.flush=1"

# 3.2.3 Ensure secure ICMP redirects are not accepted (Scored)
log "CIS" "3.2.3 Ensure secure ICMP redirects are not accepted (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.all.secure_redirects" "net.ipv4.conf.all.secure_redirects = 0"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.default.secure_redirects" "net.ipv4.conf.default.secure_redirects = 0"
execute_command "sysctl -w net.ipv4.conf.all.secure_redirects=0"
execute_command "sysctl -w net.ipv4.conf.default.secure_redirects=0"
execute_command "sysctl -w net.ipv4.route.flush=1"

# 3.2.4 Ensure suspicious packets are logged (Scored)
log "CIS" "3.2.4 Ensure suspicious packets are logged (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.all.log_martians" "net.ipv4.conf.all.log_martians = 1"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.default.log_martians" "net.ipv4.conf.default.log_martians = 1"
execute_command "sysctl -w net.ipv4.conf.all.log_martians=1"
execute_command "sysctl -w net.ipv4.conf.default.log_martians=1"
execute_command "sysctl -w net.ipv4.route.flush=1"

# 3.2.5 Ensure broadcast ICMP requests are ignored (Scored)
log "CIS" "3.2.5 Ensure broadcast ICMP requests are ignored (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.icmp_echo_ignore_broadcasts" "net.ipv4.icmp_echo_ignore_broadcasts = 1"
execute_command "sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1"
execute_command "sysctl -w net.ipv4.route.flush=1"

# 3.2.6 Ensure bogus ICMP responses are ignored (Scored)
log "CIS" "3.2.6 Ensure bogus ICMP responses are ignored (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.icmp_ignore_bogus_error_responses" "net.ipv4.icmp_ignore_bogus_error_responses = 1"
execute_command "sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1"
execute_command "sysctl -w net.ipv4.route.flush=1"

# 3.2.7 Ensure Reverse Path Filtering is enabled (Scored)
log "CIS" "3.2.7 Ensure Reverse Path Filtering is enabled (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.all.rp_filter" "net.ipv4.conf.all.rp_filter = 1"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.default.rp_filter" "net.ipv4.conf.default.rp_filter = 1"
execute_command "sysctl -w net.ipv4.conf.all.rp_filter=1"
execute_command "sysctl -w net.ipv4.conf.default.rp_filter=1"
execute_command "sysctl -w net.ipv4.route.flush=1"

# 3.2.8 Ensure TCP SYN Cookies is enabled (Scored)
log "CIS" "3.2.8 Ensure TCP SYN Cookies is enabled (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.tcp_syncookies" "net.ipv4.tcp_syncookies = 1"
execute_command "sysctl -w net.ipv4.tcp_syncookies=1"
execute_command "sysctl -w net.ipv4.route.flush=1"

# 3.2.9 Ensure IPv6 router advertisements are not accepted (Scored)
log "CIS" "3.2.9 Ensure IPv6 router advertisements are not accepted (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv6.conf.all.accept_ra" "net.ipv6.conf.all.accept_ra = 0"
line_replace "/etc/sysctl.conf" "^net.ipv6.conf.default.accept_ra" "net.ipv6.conf.default.accept_ra = 0"
execute_command "sysctl -w net.ipv6.conf.all.accept_ra=0"
execute_command "sysctl -w net.ipv6.conf.default.accept_ra=0"
execute_command "sysctl -w net.ipv4.route.flush=1"
