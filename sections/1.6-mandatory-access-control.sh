# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 1.6 Mandatory Access Control
# 1.6.1 Configure SELinux
# --------------------------------------------

# 1.6.1.1 Ensure SELinux is not disabled in bootloader configuration
log "CIS" "1.6.1.1 Ensure SELinux is not disabled in bootloader configuration"
line_replace "/etc/default/grub" "^GRUB_CMDLINE_LINUX_DEFAULT" "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet\"" "after" "GRUB_CMDLINE_LINUX="
line_replace "/etc/default/grub" "^GRUB_CMDLINE_LINUX=" "GRUB_CMDLINE_LINUX=\"\""
execute_command "grub2-mkconfig -o /boot/grub2/grub.cfg"

# 1.6.1.2 Ensure the SELinux state is enforcing (Scored)
log "CIS" "1.6.1.2 Ensure the SELinux state is enforcing (Scored)"
line_replace "/etc/selinux/config" "^SELINUX=" "SELINUX=enforcing"

# 1.6.1.3 Ensure SELinux policy is configured (Scored)
log "CIS" "1.6.1.3 Ensure SELinux policy is configured (Scored)"
line_replace "/etc/selinux/config" "^SELINUXTYPE=" "SELINUXTYPE=targeted"

# 1.6.1.4 Ensure SETroubleshoot is not installed (Scored)
log "CIS" "1.6.1.4 Ensure SETroubleshoot is not installed (Scored)"
package_remove "setroubleshoot"

# 1.6.1.5 Ensure the MCS Translation Service (mcstrans) is not installed (Scored)
log "CIS" "1.6.1.5 Ensure the MCS Translation Service (mcstrans) is not installed (Scored)"
package_remove "mcstrans"

# 1.6.1.6 Ensure no unconfined daemons exist (Scored)
log "CIS" "1.6.1.6 Ensure no unconfined daemons exist (Scored)"
unconfined_daemons=$(ps -eZ | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ':' ' ' | awk '{ print $NF }')
if [ $unconfined_daemons == "" ]; then
  printf "${GREEN}ok: (unconfined daemons) => none${NOCOLOR}\n"
  $OK=$((OK + 1))
else
  printf "${RED}failed: (unconfined daemons) => ${unconfined_daemons}${NOCOLOR}\n"
  printf "${RED}  => Investigate any unconfined daemons found during the audit action. They may need to have an existing security context assigned to them or a policy built for them.${NOCOLOR}\n"
  $FAILED=$((FAILED + 1))
fi

# 1.6.2 Ensure SELinux is installed (Scored)
log "CIS" "1.6.2 Ensure SELinux is installed (Scored)"
package_install "libselinux"
