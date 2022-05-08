#!/bin/bash
rm -f ./install.zip
zip install.zip common/* META-INF/com/google/android/* system/etc/security/cacerts/* customize.sh LICENSE module.prop post-fs-data.sh README.md uninstall.sh
git add install.zip update.json changelog.md module.prop