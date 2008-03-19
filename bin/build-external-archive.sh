#! /bin/bash
#    Build external .tar.bz2 archive, used for HTTP webserver uploads, maintainers
#    coordination and XDelta generation
#
#    Version 0.3.0
#
#    Run-time requirements: Bash, GNU tar, xdelta(*), GNU sed, GNU coreutils (prov.
#    md5sum(*), cat, sha1sum(*), GNU fileutils, BZip2
#    (*): indicates an optional requirement
#
#    Copyright (C) 2008 by Ignacio Riquelme M. <shadowm2006@gmail.com>
#    Not part of the Battle for Wesnoth Project, but part of an add-on
#    Project, "Invasion from the Unknown"
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License version 2
#    or at your option any later version.
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY.
#
#    See the COPYING file for more details.
#
#   $Id$
#
# Changelog
# ---------
# 0.3.0
# * 2008-03-17 (10:28 PM):
#             - Added svn export capabilities and a related switch
# 0.2.0
# * 2008-03-09 (08:21 PM):
#             - Script now computes MD5 and SHA1 checksums of both XDelta and generated package,
#               and writes them onto .MD5 and .SHA1 files (respectively) in the target dir
#             - Matching .ign pattern entries are removed silently to avoid clutter on stderr
# 0.1.0
# * 2008-01-29 (01:00 PM):
#               Initial version which can handle only BZip2 tarballs

if [ "$1" = "" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
	cat <<- EOD
		usage: build-external-archive.sh [--force | -f] [{--xdelta | -x} (older version)]  (output dir)
		
		--force | -f               Overwrites the target package file, should it exist in the output dir.
		--xdelta | -x              Generates a XDelta patch from 'older version'.
		--no-svn-export | -E       Does not check whether the UMC directory is a SVN checkout, and skips
		                           exporting it with the standard svn 'export' command; this may cause
		                           unnecessary files to be included in the package; don't use it unless
		                           you know what you are doing.
		
		Note that this script should be run from inside the UMC directory.
	EOD
	exit
fi

__P_FORCE="no"
__P_SVN_EXPORT="yes"
__P_XDELTA="no"
__P_XDELTA_FROM_VERSION="0.0.0"
OUTPUT_DIRECTORY="null"

# Parse command line parameters
while [ "${1}" != "" ]; do
	if [ "${1}" = "--force" ] || [ "${1}" = "-f" ]; then
		__P_FORCE="yes"
	fi
	if [ "${1}" = "--xdelta" ] || [ "${1}" = "-x" ]; then
		__P_XDELTA="yes"
		__P_XDELTA_FROM_VERSION="${2}"
		shift
	fi
	if [ "${1}" = "--no-svn-export" ] || [ "${1}" = "-E" ]; then
		__P_SVN_EXPORT="no"
	fi
	OUTPUT_DIRECTORY=${1}
	shift
done

# Check whether we are running at the utilities directory or not
if [ "`basename ${PWD}`" = "bin" ]; then
	# We are, let's go one level up to optimize file paths
	cd ..
fi

INITIAL_DIR=${PWD}

# Check that current dir is the UMC's inner root dir
if ! [ -f ${INITIAL_DIR}/_main.cfg ]; then
	echo "error: ${INITIAL_DIR}/_main.cfg not a regular file/doesn't exist. Aborting."
	cd ${INITIAL_DIR}
	exit 2
fi

UMC_NAME="`cat ./tags/list_BASEDIRS.tag`"
VERSION="`cat ./tags/VERSION.tag`"
CAMPAIGN_NAME="`sed "y/_/ /" ./tags/list_BASEDIRS.tag`"

OUTPUT_FILE_BASENAME="${UMC_NAME}-${VERSION}"
OUTPUT_ARCHIVE_FORMAT="tar"
OUTPUT_ARCHIVE_COMPRESSION_FORMAT="bz2"
OUTPUT_EXT="${OUTPUT_ARCHIVE_FORMAT}.${OUTPUT_ARCHIVE_COMPRESSION_FORMAT}"

mkdir -p $OUTPUT_DIRECTORY

# Test early enough if this is a svn checkout
if ! [ -d "./.svn" ]; then
	__P_SVN_EXPORT="no"
else
	echo "detected svn checkout"
fi

# Check that target package doesn't exist in the output dir already
if [ -f "${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}" ]; then
	if [ "${__P_FORCE}" != "yes" ]; then
		cd ${INITIAL_DIR}
		echo "error: target '${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}' already exists in output directory, ${OUTPUT_DIRECTORY}! Use --force to bypass this warning."
		exit 1
	else
		rm -f ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}
	fi
fi

# Generate fake root
echo "Creating fake root at ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/..."
mkdir -p ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/
rm -rf ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/*

if [ __P_SVN_EXPORT = "no" ]; then
	# Do a complete copy of all files
	echo "Exporting..."
	cp -a ${INITIAL_DIR} ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/${UMC_NAME}
else
	# Export svn checkout
	echo "Exporting subversion checkout..."
	svn export . ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/${UMC_NAME}
fi
# Change to fake root before working on it
cd ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/

IGNORE_LIST="*.ign *.pbl _server.*"

if [ -f ./${UMC_NAME}/_server.ign ]; then
	# We have a custom ignore list; use it
	echo "Found a custom publish ignore list (_server.ign) to append to the defaults"
	IGNORE_LIST="${IGNORE_LIST} `cat ./${UMC_NAME}/_server.ign`"
fi

echo -ne "Removing private files from package using ignore list:\n${IGNORE_LIST}\n... "
# Backup essential data files that would be removed...
mkdir -p ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/idata
cd ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/${UMC_NAME}
cp -r _main.cfg ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/idata/
cp -r _server.* ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/idata/
cp -r tags/ ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/idata/tags/
# Remove files that should be stripped from the package (using built ignore list)
rm -r -f ${IGNORE_LIST} > /dev/null
cd ..
echo "complete!"

# Now we are ready to package; produce a special release tag first
echo "Writing package tag..."
mkdir -p ./${UMC_NAME}/tags
rm -f ./${UMC_NAME}/tags/PUBLISH.tag
cat >> ./${UMC_NAME}/tags/PUBLISH.tag <<- EOD
# "${CAMPAIGN_NAME}" package automatically generated on $(date +%F-%H:%M:%S)
# running ${0} under $(uname -o) $(uname -rm) by ${USER}@${HOST}

$ version ${VERSION}
$ archive tar
$ comp bzip2
$ generator ${USER}@${HOST}
EOD

cp ./${UMC_NAME}/tags/PUBLISH.tag ./idata/tags/PUBLISH.tag

echo "Producing .tar.bz2 package... "
tar -jcf ./${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT} ./${UMC_NAME}

# Copy the package to the output dir
cp -i ./${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT} ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}

if [ "${__P_XDELTA}" = "yes" ]; then
	# Generate XDelta only if we can locate a previous version package in the same dir
	cd ${OUTPUT_DIRECTORY}
	if [ -f "./${UMC_NAME}-${__P_XDELTA_FROM_VERSION}.${OUTPUT_EXT}" ]; then
		cp -f ./${UMC_NAME}-${__P_XDELTA_FROM_VERSION}.${OUTPUT_EXT} ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/${UMC_NAME}-${__P_XDELTA_FROM_VERSION}.${OUTPUT_EXT}
		cd ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir
		# Decompress new version's package
		bunzip2 ./${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}
		# Decompress old version's package
		bunzip2 ./${UMC_NAME}-${__P_XDELTA_FROM_VERSION}.${OUTPUT_EXT}
		# Generate XDelta
		echo -n "Generating XDelta... "
		xdelta delta -q ./${UMC_NAME}-${__P_XDELTA_FROM_VERSION}.${OUTPUT_ARCHIVE_FORMAT} ./${OUTPUT_FILE_BASENAME}.${OUTPUT_ARCHIVE_FORMAT} ${OUTPUT_DIRECTORY}/${UMC_NAME}-${__P_XDELTA_FROM_VERSION}-to-${VERSION}.${OUTPUT_ARCHIVE_FORMAT}.xdelta
		__T="$?"
		if [ "0" -eq "${__T}" ]; then
			echo "no differences found"
		else
			if [ "1" -eq "${__T}" ]; then
				echo "done --> ${OUTPUT_DIRECTORY}/${UMC_NAME}-${__P_XDELTA_FROM_VERSION}-to-${VERSION}.${OUTPUT_ARCHIVE_FORMAT}.xdelta"
				# Compute message digests of XDelta patch
				md5sum ${OUTPUT_DIRECTORY}/${UMC_NAME}-${__P_XDELTA_FROM_VERSION}-to-${VERSION}.${OUTPUT_ARCHIVE_FORMAT}.xdelta > ${OUTPUT_DIRECTORY}/${UMC_NAME}-${__P_XDELTA_FROM_VERSION}-to-${VERSION}.${OUTPUT_ARCHIVE_FORMAT}.xdelta.MD5
				sha1sum ${OUTPUT_DIRECTORY}/${UMC_NAME}-${__P_XDELTA_FROM_VERSION}-to-${VERSION}.${OUTPUT_ARCHIVE_FORMAT}.xdelta > ${OUTPUT_DIRECTORY}/${UMC_NAME}-${__P_XDELTA_FROM_VERSION}-to-${VERSION}.${OUTPUT_ARCHIVE_FORMAT}.xdelta.SHA1
			else
				echo "failed"
			fi
		fi
		cd -
	else
		echo "Couldn't find file ${OUTPUT_DIRECTORY}/${UMC_NAME}-${__P_XDELTA_FROM_VERSION}.${OUTPUT_EXT}, or it is not a regular file; skipping XDelta generation."
	fi
fi

# Compute message digests of generated package
md5sum ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT} > ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}.MD5
sha1sum ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT} > ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}.SHA1

# Output an informative summary which includes MD5 and SHA1 checksums for redistribution across
# the Internet; the sed command "s/ .*$//" makes sure md5sum and sha1sum's output is processed and the
# filenames are hidden
cat <<-EOD
*****************************************************************************************
Summary of ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}
MD5 sum : $(sed "s/ .*$//" - <<< `cat ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}.MD5`)
SHA1 sum: $(sed "s/ .*$//" - <<< `cat ${OUTPUT_DIRECTORY}/${OUTPUT_FILE_BASENAME}.${OUTPUT_EXT}.SHA1`)
*****************************************************************************************

EOD

echo "Removing temporary files..."
cd ${INITIAL_DIR}
rm -rf ${TMPDIR}/${OUTPUT_FILE_BASENAME}.fakeroot.dir/

echo "Complete."




