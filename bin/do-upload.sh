#! /bin/bash
#    Upload UMC
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
# NOTE! this script assumes the UMC I made uses new-style manifest filenames! (i.e. /_main.cfg instead
# of /../UMC_Name_Goes_Here.cfg)

# Check whether we are running at the utilities directory or not
if [ "`basename ${PWD}`" = "bin" ]; then
	# We are, let's go one level up to optimize file paths
	cd ..
fi

UMC_OUTER_ROOT="`cat ./tags/list_IMPORTDIRS.tag`/data/campaigns"
UMC_INNER_ROOT="${UMC_OUTER_ROOT}/`cat ./tags/list_BASEDIRS.tag`"7

L_OLD_DIR="${PWD}"

if [ "$1" != "--invoke-i18n-suite" ]; then
	UMC_WESCAMP_CHECKOUT_ROOT="${HOME}/wescamp-IftU"
	echo "Exporting to WesCamp..."
	cd ${UMC_WESCAMP_CHECKOUT_ROOT}
	echo "> svn update"
	svn up

	echo "> running maintenance script: /bin/add-all-to-repo.sh"
	./bin/add-all-to-repo.sh
	test "$?" -eq "0" || exit $?

	echo "> running maintenance script: /bin/update-translations.sh"
	./bin/update-translations.sh
	test "$?" -eq "0" || exit $?
fi

cd ${UMC_INNER_ROOT}

echo "Optimizing PNG files on ${UMC_INNER_ROOT} (recursive)..."

wesnoth-pngcrush
echo "Uploading via campaigns_client.py..."
campaigns_client.py -p 1.3.x -c ${UMC_OUTER_ROOT} -u `cat ./tags/list_BASEDIRS.tag`
cd ${L_OLD_DIR}

echo "Completed."
