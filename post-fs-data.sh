#!/system/bin/sh
# define local
CACERTS=$MODDIR/system/etc/security/cacerts
USERCERTS=/data/misc/user/0/cacerts-added

# Run only when a user cert is present
if [[ -d $USERCERTS && "$(ls -A $USERCERTS)" ]];then
    # Move User Certs to System Store.
    mv -f $USERCERTS/* $CACERTS
    chown -R 0:0 $CACERTS

    [ "$(getenforce)" = "Enforcing" ] || exit 0

    default_selinux_context=u:object_r:system_file:s0
    selinux_context=$(ls -Zd /system/etc/security/cacerts | awk '{print $1}')

    if [ -n "$selinux_context" ] && [ "$selinux_context" != "?" ]; then
        chcon -R $selinux_context $CACERTS
    else
        chcon -R $default_selinux_context $CACERTS
    fi
fi