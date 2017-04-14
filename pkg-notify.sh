#!/bin/sh

TOKEN=
USER=

LOG="pkg.log"
MSG_TITLE=$(hostname)
URL_TITLE="_________________[pkg log]_________________"

############################################################################

if [ ! -r "$LOG" ] ; then
  FAIL=1
  echo "Insufficient permissions for log file"
else FAIL=0
fi

if [ ! -w "$LOG" ] ; then
  FAIL=1
  echo "Unable to write to log file"
else FAIL=0
fi

cat /dev/null > $LOG

pkg update >/dev/null && pkg install -y pkg >/dev/null && pkg upgrade -n > pkg.log

if [ ! -s $LOG ] ; then
 FAIL=1
 echo "Failed to get pkg output"
else FAIL=0
fi

if [ "$FAIL" -eq "0" ] ; then

  INSTALL=$(awk -F': ' '/to be installed/{printf "%s\n", $2}' $LOG)
  if [ -z "$INSTALL" ] ; then INSTALL="0" ; fi

  UPGRADE=$(awk -F': ' '/to be upgraded/{printf "%s\n", $2}' $LOG)
  if [ -z "$UPGRADE" ] ; then UPGRADE="0" ; fi

  REINSTALL=$(awk -F': ' '/to be reinstalled/{printf "%s\n", $2}' $LOG)
  if [ -z "$REINSTALL" ] ; then REINSTALL="0" ; fi

  TOTAL=$(($INSTALL+$UPGRADE+$REINSTALL))

  if [ "$TOTAL" -gt "0" ] ; then
    MESSAGE="$TOTAL total updates\n"
    PASTE=$(cat $LOG | nc termbin.com 9999)
  else echo "Nothing to update."
  fi

  if [ "$INSTALL" -gt 0 ] ; then MESSAGE=$MESSAGE"\n$INSTALL to install" ; fi
  if [ "$UPGRADE" -gt 0 ] ; then MESSAGE=$MESSAGE"\n$UPGRADE to upgrade" ; fi
  if [ "$REINSTALL" -gt 0 ] ; then MESSAGE=$MESSAGE"\n$REINSTALL to reinstall" ; fi

fi

MESSAGE=$(echo -e $MESSAGE)

if [ ! -z "$MESSAGE" ] ; then
  echo "Pushing notifitation..."
  curl -s \
    --form-string "token=$TOKEN" \
    --form-string "user=$USER" \
    --form-string "title=$MSG_TITLE" \
    --form-string "message=$MESSAGE" \
    --form-string "url=$PASTE" \
    --form-string "url_title=$URL_TITLE" \
    https://api.pushover.net/1/messages.json
else echo "Nothing to push. Exiting..."
fi
