# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 2.2 Service Clients
# --------------------------------------------

# 2.2.1 Ensure NIS Client is not installed (Scored)
log "CIS" "2.2.1 Ensure NIS Client is not installed (Scored)"
package_remove "ypbind"

# 2.2.2 Ensure rsh client is not installed (Scored)
log "CIS" "2.2.2 Ensure rsh client is not installed (Scored)"
package_remove "rsh"

# 2.2.3 Ensure talk client is not installed (Scored)
log "CIS" "2.2.3 Ensure talk client is not installed (Scored)"
package_remove "talk"

# 2.2.4 Ensure telnet client is not installed (Scored)
log "CIS" "2.2.4 Ensure telnet client is not installed (Scored)"
package_remove "telnet"

# 2.2.5 Ensure LDAP client is not installed (Scored)
log "CIS" "2.2.5 Ensure LDAP client is not installed (Scored)"
package_remove "openldap-clients"
