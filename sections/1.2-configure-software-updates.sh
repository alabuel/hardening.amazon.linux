# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 1.2 Configure Software Updates
# --------------------------------------------

# 1.2.1 Ensure package manager repositories are configured (Not Scored)
log "CIS" "1.2.1 Ensure package manager repositories are configured (Not Scored)"
execute_command "yum repolist"

# 1.2.2 Ensure GPG keys are configured (Not Scored)
log "CIS" "1.2.2 Ensure GPG keys are configured (Not Scored)"
execute_command "rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'"

# 1.2.3 Ensure gpgcheck is globally activated (Scored)
log "CIS" "1.2.3 Ensure gpgcheck is globally activated (Scored)"
execute_command "FILES='/etc/yum.repos.d/*'; for f in $FILES do; sed -i '/^gpgcheck=0/c\gpgcheck=1' $f; done"

