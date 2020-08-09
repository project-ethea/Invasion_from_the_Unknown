# Run validation tests

ADDON_NAME           := Invasion_from_the_Unknown

CAMPAIGNSYM          := CAMPAIGN_INVASION_FROM_THE_UNKNOWN
EXTRASYMS            := ENABLE_DWARVISH_RUNESMITH,ENABLE_DWARVISH_ARCANISTER

DIST_VERSION_FILE    := dist/VERSION

DIFFICULTIES         := EASY NORMAL HARD
PACKS                := __DUMMY_CONFIG_SET__

SCENARIO_DIRS        := scenarios

include ../Naia/tools/Makefile.wmltools

normalize-textdomains:
	find . \( -name '*.cfg' -o -name '*.lua' \) -type f -print0 | xargs -0 \
		sed -ri 's/wesnoth-(After_the_Storm|Era_of_Chaos)/wesnoth-Invasion_from_the_Unknown/'

clean: clean-wmltools
