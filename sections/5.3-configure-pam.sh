# Author: Ariel Abuel
# Benchmark: CIS

# --------------------------------------------
# 5.3 Configure PAM
# --------------------------------------------

# 5.3.1 Ensure password creation requirements are configured (Scored)
log "CIS" "5.3.1 Ensure password creation requirements are configured (Scored)"
line_replace "/etc/security/pwquality.conf" "^password requisite pam_pwquality.so" "password requisite pam_pwquality.so try_first_pass retry=3"
line_replace "/etc/security/pwquality.conf" "^minlen" "minlen = 14"
line_replace "/etc/security/pwquality.conf" "^dcredit" "dcredit = -1"
line_replace "/etc/security/pwquality.conf" "^ucredit" "ucredit = -1"
line_replace "/etc/security/pwquality.conf" "^ocredit" "ocredit = -1"
line_replace "/etc/security/pwquality.conf" "^lcredit" "lcredit = -1"

# 5.3.2 Ensure lockout for failed password attempts is configured (Scored)
log "CIS" "5.3.2 Ensure lockout for failed password attempts is configured (Scored)"
line_add "/etc/pam.d/password-auth" "auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900"
line_add "/etc/pam.d/password-auth" "auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900"
line_add "/etc/pam.d/password-auth" "auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900"
line_replace "/etc/pam.d/password-auth" "^auth.*pam_unix.so" "\auth [success=1 default=bad] pam_unix.so"
line_add "/etc/pam.d/system-auth" "auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900"
line_add "/etc/pam.d/system-auth" "auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900"
line_add "/etc/pam.d/system-auth" "auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900"
line_replace "/etc/pam.d/system-auth" "^auth.*pam_unix.so" "\auth [success=1 default=bad] pam_unix.so"

# 5.3.3 Ensure password reuse is limited (Scored)
log "CIS" "5.3.3 Ensure password reuse is limited (Scored)"
pam_option "/etc/pam.d/password-auth" "add" "password sufficient pam_unix.so" "remember=5"
pam_option "/etc/pam.d/system-auth" "add" "password sufficient pam_unix.so" "remember=5"

# 5.3.4 Ensure password hashing algorithm is SHA-512 (Scored)
log "CIS" "5.3.4 Ensure password hashing algorithm is SHA-512 (Scored)"
pam_option "/etc/pam.d/password-auth" "add" "password sufficient pam_unix.so" "sha512"
pam_option "/etc/pam.d/system-auth" "add" "password sufficient pam_unix.so" "sha512"
