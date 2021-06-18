# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 3 Network Configuration
# 3.1 Network Parameters (Host Only)
# --------------------------------------------

# 3.1.1 Ensure IP forwarding is disabled (Scored)
log "CIS" "3.1.1 Ensure IP forwarding is disabled (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.ip_forward" "net.ipv4.ip_forward = 0"
line_replace "/etc/sysctl.conf" "^net.ipv6.conf.all.forwarding" "net.ipv6.conf.all.forwarding = 0"
execute_command "sysctl -w net.ipv4.ip_forward=0"
execute_command "sysctl -w net.ipv6.conf.all.forwarding=0"
execute_command "sysctl -w net.ipv4.route.flush=1"
execute_command "sysctl -w net.ipv6.route.flush=1"

# 3.1.2 Ensure packet redirect sending is disabled (Scored)
log "CIS" "3.1.2 Ensure packet redirect sending is disabled (Scored)"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.all.send_redirects" "net.ipv4.conf.all.send_redirects = 0"
line_replace "/etc/sysctl.conf" "^net.ipv4.conf.default.send_redirects" "net.ipv4.conf.default.send_redirects = 0"
execute_command "sysctl -w net.ipv4.conf.all.send_redirects=0"
execute_command "sysctl -w net.ipv4.conf.default.send_redirects=0"
execute_command "sysctl -w net.ipv4.route.flush=1"
