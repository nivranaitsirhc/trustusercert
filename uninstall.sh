# define locals
CACERTS=$MODDIR/system/etc/security/cacerts
# Revert the Certs to user cert store.
if [[ -d $CACERTS && "$(ls -A $CACERTS)" ]];then
  USERCERTS=/data/misc/user/0/cacerts-added
  default_misc_context=u:object_r:misc_user_data_file:s0

  mv -f $CACERTS/* $USERCERTS
  chown -R 1000:1000 $USERCERTS
  chmod -R 644 $USERCERTS
  chcon -R $default_misc_context $USERCERTS
fi

# Don't modify anything after this
if [ -f $INFO ]; then
  while read LINE; do
    if [ "$(echo -n $LINE | tail -c 1)" == "~" ]; then
      continue
    elif [ -f "$LINE~" ]; then
      mv -f $LINE~ $LINE
    else
      rm -f $LINE
      while true; do
        LINE=$(dirname $LINE)
        [ "$(ls -A $LINE 2>/dev/null)" ] && break 1 || rm -rf $LINE
      done
    fi
  done < $INFO
  rm -f $INFO
fi
