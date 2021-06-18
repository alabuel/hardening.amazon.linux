# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 1.5 Additional Process Hardening
# --------------------------------------------

# 1.5.1 Ensure core dumps are restricted (Scored)
log "CIS" "1.5.1 Ensure core dumps are restricted (Scored)"
execute_command "sed -i '/# End of file/i *\\thard\\tcore\\t0' /etc/security/limits.conf"
execute_command "sysctl -w fs.suid_dumpable=0"

# 1.5.2 Ensure address space layout randomization (ASLR) is enabled (Scored)
log "CIS" "1.5.2 Ensure address space layout randomization (ASLR) is enabled (Scored)"
execute_command "sysctl -w kernel.randomize_va_space=2"

# 1.5.3 Ensure prelink is disabled (Scored)
log "CIS" "1.5.3 Ensure prelink is disabled (Scored)"
package_remove "prelink" "prelink -ua"
