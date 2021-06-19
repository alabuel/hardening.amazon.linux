# --------------------------------------------
# HARDENING SCRIPT for Amazon Linux 2
# Author: Ariel Abuel
# Benchmark: CIS
# --------------------------------------------

set -a

# load helper variables
. library/helper.vars

# load library functions
. library/helper.sh

# load custom parameters
. ./defaults.vars

# call by section
. sections/1.1-filesystem-configuration.sh
. sections/1.2-configure-software-updates.sh
. sections/1.3-filesystem-integrity-checking.sh
. sections/1.4-secure-boot-settings.sh
. sections/1.5-additional-process-hardening.sh
. sections/1.6-mandatory-access-control.sh
. sections/1.7-warning-banners.sh
. sections/2.1-special-purpose-services.sh
. sections/2.2-service-clients.sh
. sections/3.1-network-parameters-host-only.sh
. sections/3.2-network-parameters-host-and-router.sh
. sections/3.3-tcp-wrappers.sh
. sections/3.4-uncommon-network-protocols.sh
. sections/3.5-firewall-configuration.sh
. sections/4.1-configure-system-accounting.sh
. sections/4.2-configure-logging.sh
. sections/5.1-configure-cron.sh
. sections/5.2-ssh-server-configuration.sh
. sections/5.3-configure-pam.sh
. sections/5.4-user-accounts-and-environment.sh
. sections/6.1-system-file-permissions.sh
. sections/6.2-user-and-group-settings.sh

print_summary

set +a
