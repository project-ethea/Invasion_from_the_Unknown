# Run validation tests

ADDON_NAME           := Invasion_from_the_Unknown

CAMPAIGNSYM          := CAMPAIGN_INVASION_FROM_THE_UNKNOWN

DIST_VERSION_FILE    := dist/VERSION

DIFFICULTIES         := EASY NORMAL HARD
PACKS                := \
	CAMPAIGN_INVASION_FROM_THE_UNKNOWN_EPISODE_I \
	CAMPAIGN_INVASION_FROM_THE_UNKNOWN_EPISODE_II

SCENARIO_DIRS        := scenarios

include ../Naia/tools/Makefile.wmltools

normalize-textdomains:
	find . \( -name '*.cfg' -o -name '*.lua' \) -type f -print0 | xargs -0 \
		sed -ri 's/wesnoth-(After_the_Storm|Era_of_Chaos)/wesnoth-Invasion_from_the_Unknown/'

clean: clean-wmltools
