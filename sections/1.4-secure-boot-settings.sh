# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 1.4 Secure Boot Settings
# --------------------------------------------

# 1.4.1 Ensure permissions on bootloader config are configured (Scored)
log "CIS" "1.4.1 Ensure permissions on bootloader config are configured (Scored)"
execute_command "chown root:root /boot/grub2/grub.cfg"
execute_command "chmod og-rwx /boot/grub2/grub.cfg"

# 1.4.2 Ensure authentication required for single user mode (Scored)
log "CIS" "1.4.2 Ensure authentication required for single user mode (Scored)"
line_replace "/usr/lib/systemd/system/rescue.service" "^ExecStart=" "ExecStart=-/bin/sh -c \"/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\""
line_replace "/usr/lib/systemd/system/emergency.service" "^ExecStart=" "ExecStart=-/bin/sh -c \"/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\""
