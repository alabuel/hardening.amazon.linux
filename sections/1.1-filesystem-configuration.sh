# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 1.1   FILESYSTEM CONFIGURATION
# 1.1.1 Disable unused filesystems
# --------------------------------------------

# 1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Scored)
log "CIS" "1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install cramfs" "install cramfs /bin/true"
remove_module "cramfs"

# 1.1.1.2 Ensure mounting of hfs filesystems is disabled (Scored)
log "CIS" "1.1.1.2 Ensure mounting of hfs filesystems is disabled (Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install hfs" "install hfs /bin/true"
remove_module "hfs"

# 1.1.1.3 Ensure mounting of hfsplus filesystems is disabled (Scored)
log "CIS" "1.1.1.3 Ensure mounting of hfsplus filesystems is disabled (Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install hfsplus" "install hfsplus /bin/true"
remove_module "hfsplus"

# 1.1.1.4 Ensure mounting of squashfs filesystems is disabled (Scored)
log "CIS" "1.1.1.4 Ensure mounting of squashfs filesystems is disabled (Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install squashfs" "install squashfs /bin/true"
remove_module "squashfs"

# 1.1.1.5 Ensure mounting of udf filesystems is disabled (Scored)
log "CIS" "1.1.1.5 Ensure mounting of udf filesystems is disabled (Scored)"
line_replace "/etc/modprobe.d/CIS.conf" "^install udf" "install udf /bin/true"
remove_module "udf"

# 1.1.2 Ensure /tmp is configured (Scored)
log "CIS" "1.1.2 Ensure /tmp is configured (Scored)"
line_replace "/etc/fstab" "^tmpfs(.*)\/tmp(.*)tmpfs" "tmpfs   /tmp   tmpfs   defaults,rw,nosuid,nodev,noexec,relatime 0 0"

# 1.1.3 Ensure nodev option set on /tmp partition (Scored)
log "CIS" "1.1.3 Ensure nodev option set on /tmp partition (Scored)"
execute_command "mount -o remount,nodev /tmp"

# 1.1.4 Ensure nosuid option set on /tmp partition (Scored)
log "CIS" "1.1.4 Ensure nosuid option set on /tmp partition (Scored)"
execute_command "mount -o remount,nosuid /tmp"

# 1.1.5 Ensure noexec option set on /tmp partition (Scored)
log "CIS" "1.1.5 Ensure noexec option set on /tmp partition (Scored)"
execute_command "mount -o remount,noexec /tmp"

# 1.1.6 Ensure separate partition exists for /var (Scored)
log "CIS" "1.1.6 Ensure separate partition exists for /var (Scored)"
skip "during installation create a custom partition setup and specify a separate partition for /var"

# 1.1.7 Ensure separate partition exists for /var/tmp (Scored)
log "CIS" "1.1.7 Ensure separate partition exists for /var/tmp (Scored)"
skip "during installation create a custom partition setup and specify a separate partition for /var/tmp"

# 1.1.8 Ensure nodev option set on /var/tmp partition (Scored)
log "CIS" "1.1.8 Ensure nodev option set on /var/tmp partition (Scored)"
add_fstab_option nodev /var/tmp
execute_command "mount -o remount,nodev /var/tmp"

# 1.1.9 Ensure nosuid option set on /var/tmp partition (Scored)
log "CIS" "1.1.9 Ensure nosuid option set on /var/tmp partition (Scored)"
add_fstab_option nosuid /var/tmp
execute_command "mount -o remount,nosuid /var/tmp"

# 1.1.10 Ensure noexec option set on /var/tmp partition (Scored)
log "CIS" "1.1.10 Ensure noexec option set on /var/tmp partition (Scored)"
add_fstab_option noexec /var/tmp
execute_command "mount -o remount,noexec /var/tmp"

# 1.1.11 Ensure separate partition exists for /var/log (Scored)
log "CIS" "1.1.11 Ensure separate partition exists for /var/log (Scored)"
skip "during installation create a custom partition setup and specify a separate partition for /var/log"

# 1.1.12 Ensure separate partition exists for /var/log/audit (Scored)
log "CIS" "1.1.12 Ensure separate partition exists for /var/log/audit (Scored)"
skip "during installation create a custom partition setup and specify a separate partition for /var/log/audit"

# 1.1.13 Ensure separate partition exists for /home (Scored)
log "CIS" "1.1.13 Ensure separate partition exists for /home (Scored)"
skip "during installation create a custom partition setup and specify a separate partition for /home "

# 1.1.14 Ensure nodev option set on /home partition (Scored)
log "CIS" "1.1.14 Ensure nodev option set on /home partition (Scored)"
add_fstab_option nodev /home
execute_command "mount -o remount,nodev /home"

# 1.1.15 Ensure nodev option set on /dev/shm partition (Scored)
log "CIS" "1.1.15 Ensure nodev option set on /dev/shm partition (Scored)"
add_fstab_option nodev /dev/shm
execute_command "mount -o remount,nodev /dev/shm"

# 1.1.16 Ensure nosuid option set on /dev/shm partition (Scored)
log "CIS" "1.1.16 Ensure nosuid option set on /dev/shm partition (Scored)"
add_fstab_option nosuid /dev/shm
execute_command "mount -o remount,nosuid /dev/shm"

# 1.1.17 Ensure noexec option set on /dev/shm partition (Scored)
log "CIS" "1.1.17 Ensure noexec option set on /dev/shm partition (Scored)"
add_fstab_option noexec /dev/shm
execute_command "mount -o remount,noexec /dev/shm"

# 1.1.18 Ensure sticky bit is set on all world-writable directories (Scored)
log "CIS" "1.1.18 Ensure sticky bit is set on all world-writable directories (Scored)"
execute_command "df --local -P | awk {'if (NR!=1) print \$6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t"

# 1.1.19 Disable Automounting (Scored)
log "CIS" "1.1.19 Disable Automounting (Scored)"
service_disable "autofs"
