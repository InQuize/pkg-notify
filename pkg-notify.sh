#!/bin/sh

######################### DO NOT TOUCH THE DEFAULTS ########################

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LOG="/tmp/pkg.log"
MSG_TITLE=$(hostname)
URL_TITLE=""
DEBUG=0

############################################################################

export PATH=$PATH
DIR=$(dirname $0)

if [ ! -f "$DIR/config" ] ; then ERROR=" No config file" ; NOPUSH=1 ; fi
if [ ! -r "$DIR/config" ] ; then ERROR=" Unable to read config file" ; NOPUSH=1 ; fi

if [ -z "$ERROR" ] ; then
  . $DIR/config
  if [ -z "$USER" ] ; then ERROR=" USER not set" ; NOPUSH=1 ; fi
  if [ -z "$TOKEN" ] ; then ERROR=" TOKEN not set" ; NOPUSH=1 ; fi
fi

touch $LOG 2> /dev/null

if [ ! -f "$LOG" ] ; then ERROR=" Unable to access specified log file path" ; fi
if [ ! -r "$LOG" ] ; then ERROR=" Unable to read log file" ; fi
if [ ! -w "$LOG" ] ; then ERROR=" Unable to write to log file" ; fi

if [ "$DEBUG" -eq 1 ] ; then cat $LOG > $LOG.bak 2> /dev/null ; fi
cat /dev/null > $LOG

pkg update > /dev/null && pkg install -y pkg > /dev/null && pkg upgrade -n > $LOG

if [ ! -s $LOG ] ; then ERROR=" Failed to get pkg output" ; fi

if [ -z "$ERROR" ] ; then
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
  else echo " Nothing to update"
  fi

  if [ -z "$URL_TITLE" ] ; then URL_TITLE="Log: $PASTE" ; fi

  if [ "$INSTALL" -gt "0" ] ; then MESSAGE=$MESSAGE"\n$INSTALL to install" ; fi
  if [ "$UPGRADE" -gt "0" ] ; then MESSAGE=$MESSAGE"\n$UPGRADE to upgrade" ; fi
  if [ "$REINSTALL" -gt "0" ] ; then MESSAGE=$MESSAGE"\n$REINSTALL to reinstall" ; fi
else MESSAGE="There appears to be a problem:\n"$ERROR ; echo "$ERROR"
fi

MESSAGE=$(echo -e $MESSAGE)

if [ -n "$MESSAGE" ] ; then
  if [ -z "$NOPUSH" ] ; then
    echo " Pushing notifitation..."
    PUSH_CALL=$(curl -s \
      --form-string "token=$TOKEN" \
      --form-string "user=$USER" \
      --form-string "title=$MSG_TITLE" \
      --form-string "message=$MESSAGE" \
      --form-string "url=$PASTE" \
      --form-string "url_title=$URL_TITLE" \
      https://api.pushover.net/1/messages.json)

    PUSH_STATUS=$(echo $PUSH_CALL | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/status/ {print $2}')

    if [ "$PUSH_STATUS" -eq 1 ] ; then echo " Done" ; else echo " Something went wrong" ; fi

    if [ "$DEBUG" -eq 1 ] ; then echo -e " Pushover API answer: $PUSH_CALL " ; fi
  else echo -e " Skipping push\n Exiting...."
  fi
else echo -e " Nothing to push\n Exiting..."
fi
