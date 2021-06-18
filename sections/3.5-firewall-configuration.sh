# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 3.5 Firewall Configuration
# 3.5.1 Configure IPv4 iptables
# --------------------------------------------

# 3.5.1.1 Ensure default deny firewall policy (Scored)
log "CIS" "3.5.1.1 Ensure default deny firewall policy (Scored)"
execute_command "iptables -P INPUT DROP"
execute_command "iptables -P OUTPUT DROP"
execute_command "iptables -P FORWARD DROP"

# 3.5.1.2 Ensure loopback traffic is configured (Scored)
log "CIS" "3.5.1.2 Ensure loopback traffic is configured (Scored)"
execute_command "iptables -A INPUT -i lo -j ACCEPT"
execute_command "iptables -A OUTPUT -o lo -j ACCEPT"
execute_command "iptables -A INPUT -s 127.0.0.0/8 -j DROP"

# 3.5.1.3 Ensure outbound and established connections are configured (Not Scored)
log "CIS" "3.5.1.3 Ensure outbound and established connections are configured (Not Scored)"
execute_command "iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT"
execute_command "iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT"
execute_command "iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT"
execute_command "iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT"
execute_command "iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT"
execute_command "iptables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT"

# 3.5.1.4 Ensure firewall rules exist for all open ports (Scored)
log "CIS" "3.5.1.4 Ensure firewall rules exist for all open ports (Scored)"
# execute_command "iptables -A INPUT -p <protocol> --dport <port> -m state --state NEW -j ACCEPT"
skip "need protocol and ports for firewall rule"


# --------------------------------------------
# 3.5.2 Configure IPv6 ip6tables
# --------------------------------------------

# 3.5.2.1 Ensure IPv6 default deny firewall policy (Scored)
log "CIS" "3.5.2.1 Ensure IPv6 default deny firewall policy (Scored)"
execute_command "ip6tables -P INPUT DROP"
execute_command "ip6tables -P OUTPUT DROP"
execute_command "ip6tables -P FORWARD DROP"

# 3.5.2.2 Ensure IPv6 loopback traffic is configured (Scored)
log "CIS" "3.5.2.2 Ensure IPv6 loopback traffic is configured (Scored)"
execute_command "ip6tables -A INPUT -i lo -j ACCEPT"
execute_command "ip6tables -A OUTPUT -o lo -j ACCEPT"
execute_command "ip6tables -A INPUT -s ::1 -j DROP"

# 3.5.2.3 Ensure IPv6 outbound and established connections are configured (Not Scored)
log "CIS" "3.5.2.3 Ensure IPv6 outbound and established connections are configured (Not Scored)"
execute_command "ip6tables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT"
execute_command "ip6tables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT"
execute_command "ip6tables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT"
execute_command "ip6tables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT"
execute_command "ip6tables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT"
execute_command "ip6tables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT"

# 3.5.2.4 Ensure IPv6 firewall rules exist for all open ports (Not Scored)
log "CIS" "3.5.2.4 Ensure IPv6 firewall rules exist for all open ports (Not Scored)"
# execute_command "ip6tables -A INPUT -p <protocol> --dport <port> -m state --state NEW -j ACCEPT"
skip "For each port identified in the audit which does not have a firewall rule establish a proper rule for accepting inbound connections"

# 3.5.3 Ensure iptables is installed (Scored)
log "CIS" "3.5.3 Ensure iptables is installed (Scored)"
package_install "iptables"

# 3.6 Disable IPv6 (Not Scored)
log "CIS" "3.6 Disable IPv6 (Not Scored)"
grub_option "add" "GRUB_CMDLINE_LINUX" "ipv6.disable=1"
#line_replace "/etc/default/grub" "^GRUB_CMDLINE_LINUX=" "GRUB_CMDLINE_LINUX=\"ipv6.disable=1\""
execute_command "grub2-mkconfig -o /boot/grub2/grub.cfg"
