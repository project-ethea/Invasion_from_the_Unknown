# Run validation tests

WESNOTH = wesnoth-1.12

WESNOTH_VERSION ?= $(shell $(WESNOTH) --version 2>&1 | head -n 1)
WESNOTH_DATA_DIR ?= $(shell $(WESNOTH) --path 2>&1 | tail -n 1)
WESNOTH_CORE_DIR ?= $(WESNOTH_DATA_DIR)/data/core

ADDON_NAME=Invasion_from_the_Unknown

DIST_VERSION_FILE=dist/VERSION
DIST_PASSPHRASE_FILE=~/.wesnoth-pbl-pass

DEFSCOPE ?= macro-scope-check
WMLLINT ?= wmllint-1.12 -d
WMLINDENT ?= wmlindent-1.12
WMLXGETTEXT ?= wmlxgettext
OPTIPNG ?= wesnoth-optipng
WML_PREPROCESS ?= $(WESNOTH) -p

AUTO_DELTEMP ?= 1

MAKEFLAGS += -rR --no-print-directory

# Internal variables

targetdir := $(realpath .)

campaignsym := CAMPAIGN_INVASION_FROM_THE_UNKNOWN

difficulties := EASY NORMAL HARD
packs := \
	CAMPAIGN_INVASION_FROM_THE_UNKNOWN_EPISODE_I \
	CAMPAIGN_INVASION_FROM_THE_UNKNOWN_EPISODE_II

extrasyms := __TEST_SUITE__,ENABLE_DWARVISH_RUNESMITH,ENABLE_DWARVISH_ARCANISTER

textdomain = wesnoth-$(ADDON_NAME)

dist_version ?= $(shell cat $(DIST_VERSION_FILE))
dist_passphrase ?= $(shell sed -nE '/^$(ADDON_NAME)=(.*)$$/ { s//\1/; p; q }' $(DIST_PASSPHRASE_FILE))

all: defscope lint

indent:
	$(WMLINDENT) .

defscope:
	$(DEFSCOPE) $(wildcard ./scenarios)

lint:
	$(WMLLINT) $(WESNOTH_CORE_DIR) $(targetdir)

*.pbl: $(DIST_VERSION_FILE) $(DIST_PASSPHRASE_FILE)

%.pbl: %.pbl.in
	@echo "    PBL     $@"
	@echo $(dist_version) | fgrep -vq 'dev' || ( echo "WARNING: Not a production release: $(dist_version)" && false )
	@sed 's/@VERSION@/$(dist_version)/; s/@PASSPHRASE@/$(dist_passphrase)/' $< > $@

pbl: _server.pbl

test:
	@echo "Running preprocessor/parser test pass..."
	@echo "  Version:      $(WESNOTH_VERSION)"
	@echo "  Difficulties: $(difficulties)"
	@echo "  Episodes:     $(packs)"

	@for p in $(packs); do for d in $(difficulties); do \
		echo "    TEST    $$p -> $$d"; \
		$(WML_PREPROCESS) $(targetdir) .preprocessor.out --preprocess-defines $(extrasyms),$(campaignsym),$$d,$$p 2>&1 | tail -n +5 ; \
		test "$(AUTO_DELTEMP)" -ne 0 && rm -rf .preprocessor.out; true; \
	done; done

stats:
	@echo "Gathering WML statistics"
	@echo "  Version:      $(WESNOTH_VERSION)"
	@echo "  Difficulties: $(difficulties)"
	@echo "  Episodes:     $(packs)"

	@for p in $(packs); do for d in $(difficulties); do \
		echo "    WML     $$p -> $$d"; \
		$(WML_PREPROCESS) $(targetdir) .preprocessor.out --preprocess-defines $(extrasyms),$(campaignsym),$$d,$$p 2>&1 2> /dev/null; \
		wc -lcm .preprocessor.out/_main.cfg | awk '{printf "            %u lines, %u characters (%1.0f KiB)\n", $$1, $$2, $$3 / 1024}'; \
		test "$(AUTO_DELTEMP)" -ne 0 && rm -rf .preprocessor.out; true; \
	done; done

optipng:
	$(OPTIPNG)

%.pot:
	@echo "    POT     $*.pot"
	@find . \( -name '*.cfg' -o -name '*.lua' \) -type f -print0 | xargs -0 $(WMLXGETTEXT) --directory=$(targetdir) --domain $(textdomain) > $*.pot
	@msgfmt --statistics -o /dev/null $*.pot 2>&1 | sed -E 's/^.*\s([0-9]+)\s.*$$/            \1 strings/'

pot: $(textdomain).pot

normalize-textdomains:
	find . \( -name '*.cfg' -o -name '*.lua' \) -type f -print0 | xargs -0 \
		sed -ri 's/wesnoth-(After_the_Storm|Era_of_Chaos)/wesnoth-Invasion_from_the_Unknown/'

clean:
	$(WMLLINT) --clean $(targetdir)
	find \( -name '*.new' -o -name '*.tmp' -o -name '*.pot' -o -name '*.orig' -o -name '*.rej' -o -name '*.map.cfg' -o -name '*.pbl' \) -type f -print0 | xargs -0 rm -f
	rm -rf .preprocessor.out
