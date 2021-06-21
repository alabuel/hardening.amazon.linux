
# --------------------------------------------
# helper functions
# 
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
  IGNORE="$2"
  RT=$(eval "$COMMAND" 2>&1)
  STATUS=$?
  if [ $STATUS -eq 0 ]; then
    printf "${GREEN}ok: (%s) => %s${NOCOLOR}\n" "$COMMAND" "$RT"
    OK=$((OK + 1))
  elif [ $STATUS -ne 0 ] && [ "$IGNORE" == "ignore" ]; then
    printf "${GRAY}ignored: (%s) => %s${NOCOLOR}\n" "$COMMAND" "$RT"
    IGNORED=$((IGNORED + 1))
  else
    printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "$COMMAND" "$RT"
    FAILED=$((FAILED + 1))
  fi
}

skip()
{
  STRING="$1"
  printf "${PURPLE}skipped: %s${NOCOLOR}\n" "$STRING"
  SKIPPED=$((SKIPPED + 1))
}

ignore()
{
  STRING="$1"
  printf "${GRAY}ignored: %s${NOCOLOR}\n" "$STRING"
  IGNORED=$((IGNORED + 1))
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
    if [ "$rt" != "0" ]; then
      printf "${GREEN}ok: (%s) => %s${NOCOLOR}\n" "$STRING" "$RS"
      OK=$((OK + 1))
    else
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "$STRING" "$RS"
      FAILED=$((FAILED + 1))
    fi
  else
    printf "${GREEN}ok: (%s) => %s${NOCOLOR}\n" "$STRING" "$STRING"
    OK=$((OK + 1))
  fi
}

package_remove()
{
  package="$1"
  cleanup="$2"
  installed=$(rpm -q $package)
  not_installed=$(rpm -q $package | grep 'not installed')
  if [ ! -z "$not_installed" ]; then
    printf "${GREEN}ok: (rpm -q $package) => ${installed}${NOCOLOR}\n"
    OK=$((OK + 1))
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
  not_installed=$(rpm -q $package | grep 'not installed')
  if [ ! -z "$not_installed" ]; then
    execute_command "yum -y install $package"
  else
    printf "${GREEN}ok: (%s) => %s${NOCOLOR}\n" "rpm -q ${package}" "$installed"
    OK=$((OK + 1))
  fi
}

service_disable()
{
  service="$1"
  status=$(systemctl is-enabled $service)
  disabled=$(systemctl is-enabled $service | grep 'Failed to get unit file state')
  if [ ! -z "$disabled" ]; then
    printf "${GREEN}ok: (%s) => %s${NOCOLOR}\n" "$service" "$status"
    OK=$((OK + 1))
  else
    execute_command "systemctl disable $service"
  fi
}

service_enable()
{
  service="$1"
  status=$(systemctl is-enabled $service)
  enabled=$(systemctl is-enabled $service | grep 'enabled')
  if [ ! -z "$enabled" ]; then
    printf "${GREEN}ok: (%s) => %s${NOCOLOR}\n" "$service" "$status"
    OK=$((OK + 1))
  else
    execute_command "systemctl enable $service"
  fi
}

line_add()
{
  target="$1"
  insertline="$2"
  found=$(grep "$insertline" $target)
  if [ -f $target ] && [ -z "$found" ]; then
    execute_command "echo '$insertline' | tee -a $target"
  elif [ -f $target ] && [ ! -z "$found" ]; then
    printf "${GREEN}ok: (%s) => %s${NOCOLOR}\n" "$insertline" "already existing. no change required"
  elif [ ! -f $target ]; then
    execute_command "echo '$insertline' | tee -a $target"
  fi
}

line_replace()
{
  target="$1"
  regex="$2"
  replacement="$3"
  insert="$4"
  insertline="$5"
  regexline=$(grep "$regex" $target)
  if [ -f $target ] && [ ! -z "$regexline" ]; then
    execute_command "sed -i '/$regex/c\\${replacement}' ${target}"
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
      found=false
      IFS=' ' read -r -a options <<< "$optionline"
      for idx in "${!options[@]}"; do
        if [ ${options[idx]} == $option ]; then
          found=true
          break
        fi
      done
      [ "$found" == "false" ] && options+=("$option")
    fi
    newoptionline=$(printf "%s" "${options[*]}")
    line_replace "/etc/default/grub" "^${parameter}" "${parameter}=\"${newoptionline}\""
  else
    line_add "/etc/default/grub" "${parameter} ${option}"
  fi
}

pam_option()
{
  filename="$1"
  action="$2"
  parameter="$3"
  option="$4"
  line=$(grep "^${parameter}" /etc/pam.d/password-auth)
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
    newoptionline=$(printf "%s" "${options[*]}")
    line_replace "$filename" "^${parameter}" "${parameter} ${newoptionline}"
  else
    line_add "/etc/pam.d/password-auth" "${parameter} ${option}"
  fi
}

set_all_user_shells()
{
  excluded="$1"
  for user in `awk -F: '($3 < 1000) {print $1 }' /etc/passwd` ; do
    exclude=$(echo $excluded | grep $user)
    if [ -z "$exclude" ] && [ $user != "root" ]; then
      execute_command "usermod -L $user"
      if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]; then
        execute_command "usermod -s /sbin/nologin $user"
      fi
    fi 
  done
}

check_root_path_integrity()
{
  result=""
  if [ "`echo $PATH | grep ::`" != "" ]; then
    result="Empty Directory in PATH (::)"
    printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "root PATH integrity" "$result"
    FAILED=$((FAILED + 1))
  fi

  if [ "`echo $PATH | grep :$`" != "" ]; then
    result="Trailing : in PATH"
    printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "root PATH integrity" "$result"
    FAILED=$((FAILED + 1))
  fi

  p=`echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`
  set -- $p
  while [ "$1" != "" ]; do
    if [ "$1" = "." ]; then
      result="PATH contains ."
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "root PATH integrity" "$result"
      FAILED=$((FAILED + 1))
      shift
      continue
    fi
    if [ -d $1 ]; then
      dirperm=`ls -ldH $1 | cut -f1 -d" "`
      if [ `echo $dirperm | cut -c6` != "-" ]; then
        result="Group Write permission set on directory $1"
        printf "changed: (%s) => %s\n" "root PATH integrity" "$result"
        CHANGED=$((CHANGED + 1))
        chmod g-w $1
      fi
      if [ `echo $dirperm | cut -c9` != "-" ]; then
        result="Other Write permission set on the directory $1"
        printf "changed: (%s) => %s\n" "root PATH integrity" "$result"
        CHANGED=$((CHANGED + 1))
        chmod o-w $1
      fi
      dirown=`ls -ldH $1 | awk '{print $3}'`
      if [ "$dirown" != "root" ]; then
        result="$1 is not owned by root"
        printf "changed: (%s) => %s\n" "root PATH integrity" "$result"
        CHANGED=$((CHANGED + 1))
        chown root:root $1
      fi
    else
      result="$1 is not a directory"
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "root PATH integrity" "$result"
      FAILED=$((FAILED + 1))
    fi
    shift
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (%s) => √${NOCOLOR}\n" "root PATH integrity"
    OK=$((OK + 1))
  fi
}

check_home_directries_exist()
{
  result=""
  cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
    if [ ! -d "$dir" ]; then
      result="The home directory ($dir) of user $user does not exist."
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "HOME directories exist" "$result"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (%s) => √${NOCOLOR}\n" "HOME directories exist"
    OK=$((OK + 1))
  fi
}

unwanted_files()
{
  FILE=$1

  cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
    if [ ! -d "$dir" ]; then
      result="The home directory ($dir) of user $user does not exist."
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "$FILE" "$result"
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
    rc=$(grep -q -P "^.*?:[^:]*:$i:" /etc/group)
    if [ "$rc" != "0" ]; then
      result="Group $i is referenced by /etc/passwd but does not exist in /etc/group"
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "$FILE" "$result"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (%s) => √${NOCOLOR}\n" "all groups in /etc/passwd exist in /etc/group"
    OK=$((OK + 1))
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
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "no duplicate UIDs exist" "$result"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (%s) => √${NOCOLOR}\n" "no duplicate UIDs exist"
    OK=$((OK + 1))
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
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "no duplicate GIDs exist" "$result"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (%s) => √${NOCOLOR}\n" "no duplicate GIDs exist"
    OK=$((OK + 1))
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
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "no duplicate user names exist" "$result"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (%s) => √${NOCOLOR}\n" "no duplicate user names exist"
    OK=$((OK + 1))
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
      printf "${RED}failed: (%s) => %s${NOCOLOR}\n" "no duplicate group names exist" "$result"
      FAILED=$((FAILED + 1))
    fi
  done
  if [ -z "$result" ]; then
    printf "${GREEN}ok: (%s) => √${NOCOLOR}\n" "no duplicate group names exist"
    OK=$((OK + 1))
  fi
}

remove_module()
{
  module="$1"
  loaded=$(lsmod | grep "$module")
  if [ ! -z "$loaded" ]; then
    execute_command "rmmod $module"
  else
    ignore "Module $module is not loaded"
  fi
}