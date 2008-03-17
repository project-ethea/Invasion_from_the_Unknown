# NOTE: the contents of this file are included into other bash scripts used by
# Shadow Master's UMC maintenance tools; it is not meant to be executed directly
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
TAG_PREFIX="tags"
# NOTE: the TAG_SUFFIX here is for the svn side of the campaign; it is therefore nil as it was not
# intended for Windows shell
TAG_SUFFIX=""
# Campaign base name / directory name
TAG_FILE_LIST_BASEDIRS="list_BASEDIRS${TAG_SUFFIX}"
# UMC import directories' root (a.k.a. Wesnoth's preferences dir)
TAG_FILE_LIST_IMPORTDIRS="list_IMPORTDIRS${TAG_SUFFIX}"
# WML top-level directories
TAG_FILE_LIST_WMLDIRS="list_WMLDIRS${TAG_SUFFIX}"
# Wesnoth Map Format top-level directories
TAG_FILE_LIST_WMAPDIRS="list_WMAPDIRS${TAG_SUFFIX}"
# Campaign version tag file
# TODO: in the future I should implement a system to automagically
# update the _main.cfg and _server.pbl
TAG_FILE_PACKAGE_VERSION="VERSION${TAG_SUFFIX}"

TAG_PREFIX_ON_UMC_DIR="tags"
# Tag file name suffix used in the UMC dir to make sure the files have proper Windows Shell-compatible file type extensions
TAG_SUFFIX_ON_UMC_DIR=".tag"

TAG_FILE_ON_UMC_DIR_LIST_BASEDIRS="list_BASEDIRS${TAG_SUFFIX_ON_UMC_DIR}"
TAG_FILE_ON_UMC_DIR_LIST_IMPORTDIRS="list_IMPORTDIRS${TAG_SUFFIX_ON_UMC_DIR}"
TAG_FILE_ON_UMC_DIR_LIST_WMLDIRS="list_WMLDIRS${TAG_SUFFIX_ON_UMC_DIR}"
TAG_FILE_ON_UMC_DIR_LIST_WMAPDIRS="list_WMAPDIRS${TAG_SUFFIX_ON_UMC_DIR}"
TAG_FILE_ON_UMC_DIR_PACKAGE_VERSION="VERSION${TAG_SUFFIX_ON_UMC_DIR}"




