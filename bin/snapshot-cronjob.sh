#! /bin/bash
#    Make periodical campaign snapshots to a HDD location defined here;
#    intended for a cron job that runs daily without root privileges
#
#    Copyright (C) 2007, 2008 by Ignacio Riquelme M. <shadowm2006@gmail.com>
#    Not part of the Battle for Wesnoth Project, but part of an add-on
#    Project, "Invasion from the Unknown"
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License version 2
#    or at your option any later version.
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY.
#
#   See the COPYING file for more details.
#
#   $Id$
#
# NOTE! this script assumes the UMC I made uses the new-style manifest filenames! (i.e. /_main.cfg instead
# of /../UMC_Name_Goes_Here.cfg)
#
# If you don't comply with that convention, it is possible that the manifest doesn't get backed-up

SNAPSHOT_DIR="${HOME}/backup/daily/wesnoth-UMC"
# a symlink in my setup...
SOURCE_DIR="${HOME}/.wesnoth/data/campaigns"
TIME_STAMP="dummy"
UMC_NAME="Invasion_from_the_Unknown"
VERSION="`cat ${SOURCE_DIR}/${UMC_NAME}/tags/VERSION.tag`"

#LOGFILE="${SNAPSHOT_DIR}/${UMC_NAME}.cronjob.log"

echo "Periodical UMC snapshot cronjob for UMC "${UMC_NAME}" started on"
echo "$(date -R) under $(uname -o) $(uname -rm) by ${USER}@${HOST}"

# Probe whether the directory exists and has a suitable manifest
if ! [ -f ${SOURCE_DIR}/${UMC_NAME}/_main.cfg ]; then
	# Toast
	echo "error: ${SOURCE_DIR}/${UMC_NAME}/_main.cfg not a regular file/doesn't exist. aborting."
	exit
fi

# Work on a fake root dir
mkdir -p ${SNAPSHOT_DIR}/${UMC_NAME}/.fakeroot
rm -r -f ${SNAPSHOT_DIR}/${UMC_NAME}/.fakeroot/*
echo "Making fake root..."
cp -a ${SOURCE_DIR}/${UMC_NAME} ${SNAPSHOT_DIR}/${UMC_NAME}/.fakeroot/${UMC_NAME}
cd ${SNAPSHOT_DIR}/${UMC_NAME}/.fakeroot
TIME_STAMP="$(date +%F-%H%M%S)"
echo "Generated timestamp: $TIME_STAMP"
echo "Changing to fake root and packaging as BZip2 tarball..."
tar -jcvf ./${UMC_NAME}-${VERSION}-${TIME_STAMP}.tar.bz2 ./${UMC_NAME}
mv ./${UMC_NAME}-${VERSION}-${TIME_STAMP}.tar.bz2 ..
cd -
rm -r -f ${SNAPSHOT_DIR}/${UMC_NAME}/.fakeroot/*

echo "Completed."
