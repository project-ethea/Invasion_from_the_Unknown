#! /bin/bash
#    Do a recursive svn add of every new file found, after
#    updating specific directories.
#
#    Version 0.10.0
#
#    Copyright (C) 2007, 2008 by Ignacio Riquelme M. <shadowm2006@gmail.com>
#    Part of the WesCamp-i18n Project
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License version 2
#    or at your option any later version.
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY.
#
#   See the COPYING file for more details.
#
# Changelog
# ---------
# 0.10.0
# * 2008-01-30 (???):
#               Bump version
# 0.9.2
# * 2008-01-28 (01:58 AM):
#               Major suite optimization
# * 2008-01-27 (04:14 AM):
#               Various updates I'm too lazy to describe
# 0.9.1
# * 2007-12-04 (10:04 PM):
#               Added more sanity checks, better output, etc.
#               Also can decide how to resolve missing files in the UMC or Wescamp checkout dirs
#               Optimized a bit (less disk I/O requests for the tagfiles), possibly making
#               the script more human-readable in the process. :-P
# * 2007-12-04 (01:00 AM):
#               Fixed the campaign's inner root dir not being
#               processed and updated
# * 2007-12-03: Initial release 0.9.0
# * 2007-11-??: Initial attempt
#

# Check whether we are running at the utilities directory or not
if [ "`basename ${PWD}`" = "bin" ]; then
	# We are, let's go one level up to optimize file paths
	cd ..
fi

. ./bin/setup_env.inc
. ./bin/sanity_checks_from_wescamp.inc

# Exit with the sanity check result if it didn't succeed
test "$?" -eq "0" || exit $?

# Now we can proceed with our task
echo "Importing from UMC dir..."
echo "> getting dirlist..."

UMC_DIRS="`cat ./${TAG_PREFIX}/${TAG_FILE_LIST_WMLDIRS}`"

echo "> updating..."

for d in ${UMC_DIRS}; do
	echo ">>: /${BASE_DIR}/${d}"
	# Don't output anything except in case of errors, unless --strict was passed as parameter
	cp -uR ${CAMPAIGN_DIR}/$d/* ./${BASE_DIR}/$d 2> ./__cp_output.temp
	if [ $? -ne 0 ] && [ "$1" = "--strict" ]; then
		echo -e "> an error ocurred during update process:\n`cat ./__cp_output.temp`\n> aborting..." && rm ./__cp_output.temp
		exit
	fi
	if test -d ./${BASE_DIR}/$d; then
		svn add --force ./${BASE_DIR}/$d
	fi
done

# Do the same manually with the inner root
echo ">>: /${BASE_DIR}/"
for f in ${CAMPAIGN_DIR}/*.cfg; do
	cp -uR $f ./${BASE_DIR}/`basename $f`
	svn add --force ./${BASE_DIR}/`basename $f`
done

echo "Completed. Now you are ready to do your commit!"
