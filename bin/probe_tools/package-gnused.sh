if [ $(sed --version | grep "GNU sed") = "" ]; then
	echo -e "PROBE: failed to detect GNU sed; please install the \"GNU-sed\" package first!"
	return -1
fi
