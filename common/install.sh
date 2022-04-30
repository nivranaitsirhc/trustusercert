# define local
CACERTS=$MODPATH/system/etc/security/cacerts
OLDCERTS=/data/adb/modules/trustusercert/system/etc/security/cacerts
# check if system file exist else create
if [ ! -d $CACERTS ];then
    ui_print "-- creating directories"
    mkdir -p $CACERTS
fi

# check if we have previous certs installed
if [[ -d $OLDCERTS && "$(ls -A $OLDCERTS)" ]];then
    ui_print "-- Copying certificates from previous installation"
    # copy old ca certs
    cp -f $OLDCERTS/* $CACERTS
    chown -R 0:0 $CACERTS

    default_selinux_context=u:object_r:system_file:s0
    selinux_context=$(ls -Zd /system/etc/security/cacerts | awk '{print $1}')

    if [ -n "$selinux_context" ] && [ "$selinux_context" != "?" ]; then
        chcon -R $selinux_context $CACERTS
    else
        chcon -R $default_selinux_context $CACERTS
    fi
fi