# NOTE: the contents of this file are included into other bash scripts used by
# Shadow Master's UMC maintenance tools; it is not meant to be executed directly
#
#    WesCamp-i18n repository entry sanity check script, which also prepares most of the
#    required environment variables
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

if [ "" = "${TAG_PREFIX}" ]; then
	# The caller script didn't setup primary environment
	. ./bin/setup_env.inc
fi

echo "Checking WesCamp checkout integrity (fast method)..."

if ! [ -d ./po ]; then
	echo "> po source directory does not exist, or ./po is not a directory!"
	return 1
fi

if ! [ -f ./${TAG_PREFIX}/${TAG_FILE_LIST_BASEDIRS} ]; then
	echo "> essential tag file '${TAG_FILE_LIST_BASEDIRS}' cannot be found in ${PWD}/${TAG_PREFIX}"
	return 1
fi

BASE_DIR="`cat ./${TAG_PREFIX}/${TAG_FILE_LIST_BASEDIRS}`"

if ! [ -d ./${BASE_DIR} ]; then
	echo "> base directory of check out, '${BASE_DIR}', does not exist, or is not a directory!"
	return 1
fi

# Some platforms or environments seem not to provide the HOME env. variable
if [ $HOME ]; then
	IMPORT_DIR="$HOME/.wesnoth"
else
	IMPORT_DIR="~/.wesnoth"
fi

if ! [ -f ./${TAG_PREFIX}/${TAG_FILE_LIST_IMPORTDIRS} ]; then
	echo "> essential tag file '${TAG_FILE_LIST_IMPORTDIRS}' cannot be found in <current directory>/${TAG_PREFIX}; assuming standard Wesnoth preferences directory as '$IMPORT_DIR'!"
else
	IMPORT_DIR="`cat ./${TAG_PREFIX}/${TAG_FILE_LIST_IMPORTDIRS}`"
fi

echo "Scanning UMC dir integrity..."

# Initialize directory matches for WML import
CAMPAIGN_DIR="${IMPORT_DIR}/data/campaigns/${BASE_DIR}"

# Probe campaign directory
if ! [ -d $CAMPAIGN_DIR ]; then
	echo "> UMC dir '${CAMPAIGN_DIR}' does not exist or is not a directory!"
	return 1
fi

# Probe manifest file (try with both old-style and new-style flavors)
if [ -f "${CAMPAIGN_DIR}.cfg" ]; then
	CAMPAIGN_MANIFEST="${CAMPAIGN_DIR}.cfg"
else
	if [ -f "${CAMPAIGN_DIR}/_main.cfg" ]; then
		CAMPAIGN_MANIFEST="${CAMPAIGN_DIR}/_main.cfg"
	else
		echo "> could not find a suitable UMC manifest file; UMC might be broken!"
	fi
fi

# As everything seems to be fine so far, try to update tagfiles if they
# are present in the UMC dir, importing them to WesCamp. If they are missing,
# copy them to the UMC dir

echo "Verifying tagfiles integrity..."

function restore_or_update_tagfile_on_UMC_dir()
{
	__P_ON_UMC_DIR_TAGFILENAME="${1}${TAG_SUFFIX_ON_UMC_DIR}"
	__P_ON_WESCAMP_TAGFILENAME="${1}${TAG_SUFFIX}"

	if ! [ -f ${CAMPAIGN_DIR}/${TAG_PREFIX_ON_UMC_DIR}/${__P_ON_UMC_DIR_TAGFILENAME} ]; then
		# tagfille missing on UMC, checking if it is on WesCamp
		if ! [ -f ./${TAG_PREFIX}/${__P_ON_WESCAMP_TAGFILENAME} ]; then
			# missing at both locations, we can't work it out ourselves
			echo "> tag file ${1} missing both in UMC dir and WesCamp checkout, or is not a regular file!"
			return 3
		fi
		# restore using the copy at WesCamp
		cp ./${TAG_PREFIX}/${__P_ON_WESCAMP_TAGFILENAME} ${CAMPAIGN_DIR}/${TAG_PREFIX_ON_UMC_DIR}/${__P_ON_UMC_DIR_TAGFILENAME}
		echo "> restored missing tag file ${1} in UMC dir"
	else
		# tagfile present on UMC, let's check for updates
		if [ ${CAMPAIGN_DIR}/${TAG_PREFIX_ON_UMC_DIR}/${__P_ON_UMC_DIR_TAGFILENAME} -nt ./${TAG_PREFIX}/${__P_ON_WESCAMP_TAGFILENAME} ]; then
			cp -u ${CAMPAIGN_DIR}/${TAG_PREFIX_ON_UMC_DIR}/${__P_ON_UMC_DIR_TAGFILENAME} ./${TAG_PREFIX}/${__P_ON_WESCAMP_TAGFILENAME}
			echo "> tag file ${1} out-dated in WesCamp check-out; fixed by updating from UMC dir"
		else
			if [ ${CAMPAIGN_DIR}/${TAG_PREFIX_ON_UMC_DIR}/${__P_ON_UMC_DIR_TAGFILENAME} -ot ./${TAG_PREFIX}/${__P_ON_WESCAMP_TAGFILENAME} ]; then
				cp -u ./${TAG_PREFIX}/${__P_ON_WESCAMP_TAGFILENAME} ${CAMPAIGN_DIR}/${TAG_PREFIX_ON_UMC_DIR}/${__P_ON_UMC_DIR_TAGFILENAME}
				echo "> tag file ${1} out-dated in UMC dir; fixed by updating from WesCamp check-out"
			fi
		fi
	fi
	return 0
}

restore_or_update_tagfile_on_UMC_dir list_BASEDIRS
test "$?" -eq "0" || return $?
restore_or_update_tagfile_on_UMC_dir list_IMPORTDIRS
test "$?" -eq "0" || return $?
restore_or_update_tagfile_on_UMC_dir list_WMLDIRS
test "$?" -eq "0" || return $?
restore_or_update_tagfile_on_UMC_dir list_WMAPDIRS
test "$?" -eq "0" || return $?
restore_or_update_tagfile_on_UMC_dir VERSION
test "$?" -eq "0" || return $?
