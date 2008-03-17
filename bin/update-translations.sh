#! /bin/bash
#    Export translations compiled after a po-update to the UMC dir.
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
#   $Id$
#

# Check whether we are running at the utilities directory or not
if [ "`basename ${PWD}`" = "bin" ]; then
	# We are, let's go one level up to optimize file paths
	cd ..
fi

# Set commonly used variables
WESCAMP_PO_DIR="./po"
WESCAMP_LANG_LIST="`cat ./po/LINGUAS`"

. ./bin/setup_env.inc
. ./bin/sanity_checks_from_wescamp.inc

# Exit with the sanity check result if it didn't succeed
test "$?" -eq "0" || exit $?

if [ "$1" != "--no-po-update" ]; then
	echo "Performing po-update..."
	make -s
	if [ $? -ne 0 ]; then
		echo "> an error ocurred during po-update. Aborting..."
		exit
	fi
else
	echo "Skipping po-update..."
fi

echo "Generating list of translations with more than 0 strings translated..."
# WESCAMP_LANG_LIST

# Rhonda and Isaac suggested that I used msgfmt --statistics infile.po -o /dev/null in
# order to get a translation statistic, and then parse the command's output. However
# since it's a bit tricky (I don't know how to write a parser in Perl, Python or Bash)
# I found another good method to know whether a .mo file has any string translated!
# Requires the user to have installed msgunfmt (I suppose it ships with the other
# gettext tools by default)

cd .
WESCAMP_ROOT_DIR="`cd -`"
LANGS_TO_EXPORT=""

for lang in ${WESCAMP_LANG_LIST}; do
	cd ${WESCAMP_ROOT_DIR}/${BASE_DIR}/translations/${lang}/LC_MESSAGES/
	if [ -f ./wesnoth-${BASE_DIR}.mo ]; then
		msgunfmt ./wesnoth-${BASE_DIR}.mo -o ./wesnoth-${BASE_DIR}.gpo
		if [ -f ./wesnoth-${BASE_DIR}.gpo ] && [ $? -eq 0 ] ; then
			LANGS_TO_EXPORT="${LANGS_TO_EXPORT} ${lang}"
			echo "> added ${lang}"
		fi
		rm -f ./wesnoth-${BASE_DIR}.gpo
	fi
done

cd ${WESCAMP_ROOT_DIR}
# Ready for action...
echo -n "Exporting... "

for e in ${LANGS_TO_EXPORT}; do
	mkdir -p ${CAMPAIGN_DIR}/translations/${e}/LC_MESSAGES
	cp ${WESCAMP_ROOT_DIR}/${BASE_DIR}/translations/${e}/LC_MESSAGES/wesnoth-${BASE_DIR}.mo ${CAMPAIGN_DIR}/translations/${e}/LC_MESSAGES/wesnoth-${BASE_DIR}.mo
	echo -n "$e "
done
echo

echo "Completed."
