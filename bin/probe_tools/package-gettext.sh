if [ $(msgfmt --version | grep "gettext-tools") = "" ]; then
	echo -e "PROBE: failed to detect gettext-tools; please install the \"gettext-tools\" package first!"
	return -1
fi
