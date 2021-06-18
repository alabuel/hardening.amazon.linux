
# --------------------------------------------
# helper functions
# --------------------------------------------
# Author: Ariel Abuel
# Benchmark: CIS
# --------------------------------------------

log()
{
  line="****************************************************************************************************"
  STRING="$1 [$2]"
  echo ""
  echo $STRING "${line:${#STRING}}"
}

execute_command()
{
  COMMAND="$1"
  RT=$(eval "$COMMAND" 2>&1)
  STATUS=$?
  if [ $STATUS -eq 0 ]; then
    printf "${GREEN}ok: ($COMMAND) => ${RT}${NOCOLOR}\n"
    OK=$((OK + 1))
  else
    printf "${RED}failed: ($COMMAND) => ${RT}${NOCOLOR}\n"
    FAILED=$((FAILED + 1))
  fi
}

skip()
{
  STRING="$1"
  printf "${PURPLE}SKIP: ${STRING}${NOCOLOR}\n"
  SKIPPED=$((SKIPPED + 1))
}

print_summary()
{
  log "END" "Summary"
  printf "Status: ${GREEN}ok=$OK${NOCOLOR}   changed=${CHANGED}   ${RED}failed=$FAILED${NOCOLOR}   ${PURPLE}skipped=$SKIPPED${NOCOLOR}   ${GRAY}ignored=$IGNORED${NOCOLOR}\n\n"
}

add_fstab_option()
{
  OPTION=$1
  REGEX=$2
  STRING=$(grep $REGEX /etc/fstab)
  OPTIONS=$(echo $STRING | awk '{print $4}')
  OPTIONEXIST=$(echo $OPTIONS | grep $OPTION; echo $?)
  if [ $OPTIONEXIST -eq 1 ]; then
    NEWOPTS="$OPTIONS,$OPTION"
    REPLACE=$(echo $STRING | awk -v OPTS=$NEWOPTS '{print $1 "\t" $2 "\t" $3 "\t" OPTS "\t" $5 "\t" $6}')
    RS=$(sed -i '/$STRING/c\$REPLACE' /etc/fstab 2>&1)
    rt=$?
    if [ $rt -eq 0 ]; then
      printf "${GREEN}ok: ($STRING) => ${RS}${NOCOLOR}\n"
      $OK=$((OK + 1))
    else
      printf "${RED}failed: ($COMMAND) => ${RS}${NOCOLOR}\n"
      $FAILED=$((FAILED + 1))
    fi
  else
    printf "${GREEN}ok: ($STRING) => ${STRING}${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}

package_remove()
{
  package="$1"
  cleanup="$2"
  installed=$(rpm -q $package)
  if rpm -q $package | grep 'not installed'; then
    printf "${GREEN}ok: (rpm -q $package) => ${installed}${NOCOLOR}\n"
    $OK=$((OK + 1))
  else
    if [ $cleanup != "" ]; then
      execute_command "$cleanup"
    fi
    execute_command "yum -y remove $package"
  fi
}

package_install()
{
  package="$1"   
  installed=$(rpm -q $package)
  if rpm -q $package | grep 'not installed'; then
    execute_command "yum -y install $package"
  else
    printf "${GREEN}ok: (rpm -q $package) => ${installed}${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}

service_disable()
{
  service="$1"
  status=$(systemctl is-enabled $service)
  if systemctl is-enabled $service | grep 'Failed to get unit file state'; then
    printf "${GREEN}ok: ($service) => ${status}${NOCOLOR}\n"
    $OK=$((OK + 1))
  else
    execute_command "systemctl disable $service"
  fi
}

service_enable()
{
  service="$1"
  status=$(systemctl is-enabled $service)
  if systemctl is-enabled $service | grep 'enabled'; then
    printf "${GREEN}ok: ($service) => ${status}${NOCOLOR}\n"
    $OK=$((OK + 1))
  else
    execute_command "systemctl enable $service"
  fi
}

line_add()
{
  target="$1"
  insertline="$2"
  execute_command "echo '$insertline' | tee -a $target"
}

line_replace()
{
  target="$1"
  regex="$2"
  replacement="$3"
  insert="$4"
  insertline="$5"
  if [ -f $target ] && [ "$(grep $regex $target)" ]; then
    execute_command "sed -i '/$regex/c\\$replacement' $target"
  else
    if [ "$insert" == "after" ] && [ "$insertline" != "" ]; then
      execute_command "sed -i '/$insertline/a $replacement' $target"
    elif [ "$insert" == "before" ] && [ "$insertline" != "" ]; then
      execute_command "sed -i '/$insertline/i $replacement' $target"
    else
      execute_command "echo '$replacement' | tee -a $target"
    fi
  fi
}

grub_option()
{
  action="$1"
  parameter="$2"
  option="$3"
  line=$(grep "^$parameter" /etc/default/grub)
  if [ "$line" != "" ]; then
    optionline=$(echo $line | awk -F= '{print $2}' | sed 's/"//g')
    IFS=' ' read -r -a options <<< "$optionline"
    if [ $action == 'delete' ]; then
      for idx in "${!options[@]}"; do
        if [ ${options[idx]} == $option ]; then
          unset ${options[idx]}
          break
        fi
      done
    elif [ $action == 'add' ]; then
      options+=("$option")
    fi
    newoptionline=$(printf "'%s'" "${arr[*]}")
    line_replace "/etc/default/grub" "^${parameter}" "${parameter}=\"${newoptionline}\""
  fi
}

pam_option()
{
  filename="$1"
  action "$2"
  parameter="$3"
  option="$4"
  line=$(grep "^$parameter" /etc/pam.d/password-auth)
  if [ "$line" != "" ]; then
    optionline=$(echo $line | awk -F"${parameter}" '{print $2}')
    IFS=' ' read -r -a options <<< "$optionline"
    if [ $action == 'delete' ]; then
      for idx in "${!options[@]}"; do
        if [ ${options[idx]} == $option ]; then
          unset ${options[idx]}
          break
        fi
      done
    elif [ $action == 'add' ]; then
      options+=("$option")
    fi
    newoptionline=$(printf "'%s'" "${arr[*]}")
    line_replace "$filename" "^${parameter}" "${parameter} ${newoptionline}"
  fi
}

set_all_user_shells()
{
  excluded="$1"
  for user in `awk -F: '($3 < 1000) {print $1 }' /etc/passwd` ; do
    exclude=$(echo $excluded | grep $user)
    if [ -z "$exclude" ] && [ $user != "root" ]; then
      usermod -L $user
      if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]; then
        usermod -s /sbin/nologin $user
      fi
    fi 
  done
}

check_root_path_integrity()
{
  result=""
  if [ "`echo $PATH | grep ::`" != "" ]; then
    result="Empty Directory in PATH (::)"
    printf "${RED}failed: (root PATH integrity) => ${result}${NOCOLOR}\n"
    FAILED=$((FAILED + 1))
  fi

  if [ "`echo $PATH | grep :$`" != "" ]; then
    result="Trailing : in PATH"
    printf "${RED}failed: (root PATH integrity) => ${result}${NOCOLOR}\n"
    FAILED=$((FAILED + 1))
  fi

  p=`echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`
  set -- $p
  while [ "$1" != "" ]; do
    if [ "$1" = "." ]; then
      result="PATH contains ."
      printf "${RED}failed: (root PATH integrity) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
      shift
      continue
    fi
    if [ -d $1 ]; then
      dirperm=`ls -ldH $1 | cut -f1 -d" "`
      if [ `echo $dirperm | cut -c6` != "-" ]; then
        result="Group Write permission set on directory $1"
        printf "changed: (root PATH integrity) => ${result}\n"
        CHANGED=$((CHANGED + 1))
        chmod g-w $1
      fi
      if [ `echo $dirperm | cut -c9` != "-" ]; then
        result="Other Write permission set on the directory $1"
        printf "changed: (root PATH integrity) => ${result}\n"
        CHANGED=$((CHANGED + 1))
        chmod o-w $1
      fi
      dirown=`ls -ldH $1 | awk '{print $3}'`
      if [ "$dirown" != "root" ]; then
        result="$1 is not owned by root"
        printf "changed: (root PATH integrity) => ${result}\n"
        CHANGED=$((CHANGED + 1))
        chown root:root $1
      fi
    else
      result="$1 is not a directory"
      printf "${RED}failed: (root PATH integrity) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
    fi
    shift
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (root PATH integrity) => √${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}

check_home_directries_exist()
{
  result=""
  cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
    if [ ! -d "$dir" ]; then
      result="The home directory ($dir) of user $user does not exist."
      printf "${RED}failed: (HOME directories exist) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (HOME directories exist) => √${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}

unwanted_files()
{
  FILE=$1

  cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
    if [ ! -d "$dir" ]; then
      result="The home directory ($dir) of user $user does not exist."
      printf "${RED}failed: ($FILE) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
    else
      if [ ! -h "$dir/$FILE" -a -f "$dir/$FILE" ]; then
        execute_command "rm -rf $dir/$FILE"
      fi
    fi
  done
}

check_passwd_in_group()
{
  result=""
  for i in $(cut -s -d: -f4 /etc/passwd | sort -u); do
    grep -q -P "^.*?:[^:]*:$i:" /etc/group
    if [ $? -ne 0 ]; then
      result="Group $i is referenced by /etc/passwd but does not exist in /etc/group"
      printf "${RED}failed: ($FILE) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
    fi
  done4
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (all groups in /etc/passwd exist in /etc/group) => √${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}

check_duplicate_uid()
{
  result=""
  cat /etc/passwd | cut -f3 -d":" | sort -n | uniq -c | while read x; do
    [ -z "${x}" ] && break
    set - $x
    if [ $1 -gt 1 ]; then
      users=`awk -F: '($3 == n) {print $1}' n=$2 /etc/passwd | xargs`
      result="Duplicate UID ($2): ${users}"
      printf "${RED}failed: (no duplicate UIDs exist) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (no duplicate UIDs exist) => √${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}

check_duplicate_gid()
{
  result=""
  cat /etc/passwd | cut -f3 -d":" | sort -n | uniq -c | while read x; do
    [ -z "${x}" ] && break
    set - $x
    if [ $1 -gt 1 ]; then
      groups=`awk -F: '($3 == n) {print $1}' n=$2 /etc/group | xargs`
      result="Duplicate GID ($2): ${groups}"
      printf "${RED}failed: (no duplicate GIDs exist) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (no duplicate GIDs exist) => √${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}

check_duplicate_user()
{
  result=""
  cat /etc/passwd | cut -f3 -d":" | sort -n | uniq -c | while read x; do
    [ -z "${x}" ] && break
    set - $x
    if [ $1 -gt 1 ]; then
      uids=`awk -F: '($1 == n) {print $3}' n=$2 /etc/passwd | xargs`
      result="Duplicate User Name ($2): ${uids}"
      printf "${RED}failed: (no duplicate user names exist) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (no duplicate user names exist) => √${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}

check_duplicate_group()
{
  result=""
  cat /etc/passwd | cut -f3 -d":" | sort -n | uniq -c | while read x; do
    [ -z "${x}" ] && break
    set - $x
    if [ $1 -gt 1 ]; then
      gids=`awk -F: '($1 == n) {print $3}' n=$2 /etc/group | xargs`
      result="Duplicate Group Name ($2): ${gids}"
      printf "${RED}failed: (no duplicate group names exist) => ${result}${NOCOLOR}\n"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (no duplicate group names exist) => √${NOCOLOR}\n"
    $OK=$((OK + 1))
  fi
}