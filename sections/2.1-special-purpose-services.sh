# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 2 Services
# 2.1 Special Purpose Services
# 2.1.1 Time Synchronization
# --------------------------------------------

# 2.1.1.1 Ensure time synchronization is in use (Not Scored)
log "CIS" "2.1.1.1 Ensure time synchronization is in use (Not Scored)"
[[ "$USE_NTP" == "yes" ]] && package_install "ntp"
[[ "$USE_CHRONY" == "yes" ]] && package_install "chrony"

# 2.1.1.2 Ensure ntp is configured (Scored)
log "CIS" "2.1.1.2 Ensure ntp is configured (Scored)"
if [ "$USE_NTP" == "yes" ]; then
  line_replace "/etc/ntp.conf" "restrict -4 default" "restrict -4 default kod nomodify notrap nopeer noquery"
  line_replace "/etc/ntp.conf" "restrict -6 default" "restrict -6 default kod nomodify notrap nopeer noquery"
  [ ! -z "$NTP_REMOTE_SERVER" ] && line_replace "/etc/ntp.conf" "^server " "server $NTP_REMOTE_SERVER" || skip "no NTP remote server configured"
  line_replace "/etc/ntp.conf" "^OPTIONS=" "OPTIONS=\"-u ntp:ntp\""
else
  skip "NTP not in use"
fi

# 2.1.1.3 Ensure chrony is configured (Scored)
log "CIS" "2.1.1.3 Ensure chrony is configured (Scored)"
if [ "$USE_CHRONY" == "yes" ]; then
  line_replace "/etc/chrony.conf" "^server " "server $CHRONY_REMOTE_SERVER"
  line_replace "/etc/chrony.conf" "^OPTIONS=" "OPTIONS=\"-u chrony\""
else
  skip "CHRONY not in use"
fi

# 2.1.2 Ensure X Window System is not installed (Scored)
log "CIS" "2.1.2 Ensure X Window System is not installed (Scored)"
package_remove "xorg-x11*"

# 2.1.3 Ensure Avahi Server is not enabled (Scored)
log "CIS" "2.1.3 Ensure Avahi Server is not enabled (Scored)"
service_disable "avahi-daemon"

# 2.1.4 Ensure CUPS is not enabled (Scored)
log "CIS" "2.1.4 Ensure CUPS is not enabled (Scored)"
service_disable "cups"

# 2.1.5 Ensure DHCP Server is not enabled (Scored)
log "CIS" "2.1.5 Ensure DHCP Server is not enabled (Scored)"
service_disable "dhcp"

# 2.1.6 Ensure LDAP server is not enabled (Scored)
log "CIS" "2.1.6 Ensure LDAP server is not enabled (Scored)"
service_disable "slapd"

# 2.1.7 Ensure NFS and RPC are not enabled (Scored)
log "CIS" "2.1.7 Ensure NFS and RPC are not enabled (Scored)"
service_disable "nfs"
service_disable "nfs-server"
service_disable "rpcbind"

# 2.1.8 Ensure DNS Server is not enabled (Scored)
log "CIS" "2.1.8 Ensure DNS Server is not enabled (Scored)"
service_disable "named"

# 2.1.9 Ensure FTP Server is not enabled (Scored)
log "CIS" "2.1.9 Ensure FTP Server is not enabled (Scored)"
service_disable "vsftpd"

# 2.1.10 Ensure HTTP server is not enabled (Scored)
log "CIS" "2.1.10 Ensure HTTP server is not enabled (Scored)"
service_disable "httpd"

# 2.1.11 Ensure IMAP and POP3 server is not enabled (Scored)
log "CIS" "2.1.11 Ensure IMAP and POP3 server is not enabled (Scored)"
service_disable "dovecot"

# 2.1.12 Ensure Samba is not enabled (Scored)
log "CIS" "2.1.12 Ensure Samba is not enabled (Scored)"
service_disable "smb"

# 2.1.13 Ensure HTTP Proxy Server is not enabled (Scored)
log "CIS" "2.1.13 Ensure HTTP Proxy Server is not enabled (Scored)"
service_disable "squid"

# 2.1.14 Ensure SNMP Server is not enabled (Scored)
log "CIS" "2.1.14 Ensure SNMP Server is not enabled (Scored)"
service_disable "snmpd"

# 2.1.15 Ensure mail transfer agent is configured for local-only mode (Scored)
log "CIS" "2.1.15 Ensure mail transfer agent is configured for local-only mode (Scored)"
line_replace "/etc/postfix/main.cf" "^inet_interfaces" "inet_interfaces = loopback-only"
execute_command "systemctl restart postfix"

# 2.1.16 Ensure NIS Server is not enabled (Scored)
log "CIS" "2.1.16 Ensure NIS Server is not enabled (Scored)"
service_disable "ypserv"

# 2.1.17 Ensure rsh server is not enabled (Scored)
log "CIS" "2.1.17 Ensure rsh server is not enabled (Scored)"
service_disable "rsh.socket"
service_disable "rlogin.socket"
service_disable "rexec.socket"

# 2.1.18 Ensure telnet server is not enabled (Scored)
log "CIS" "2.1.18 Ensure telnet server is not enabled (Scored)"
service_disable "telnet.socket"

# 2.1.19 Ensure tftp server is not enabled (Scored)
log "CIS" "2.1.19 Ensure tftp server is not enabled (Scored)"
service_disable "tftp.socket"

# 2.1.20 Ensure rsync service is not enabled (Scored)
log "CIS" "2.1.20 Ensure rsync service is not enabled (Scored)"
service_disable "rsyncd"

# 2.1.21 Ensure talk server is not enabled (Scored)
log "CIS" "2.1.21 Ensure talk server is not enabled (Scored)"
service_disable "ntalk"
