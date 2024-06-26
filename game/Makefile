include build_conf/vars.mk

TARGETS = bin debug release no-splash tests

all: all-asm

all-asm: $(BIN) $(TARGETS)

bin: 
	mkdir $(BIN)

debug: $(BIN)/$(SNA_DEBUG).sna

release: $(BIN)/$(SNA_RELEASE).sna

no-splash: $(BIN)/$(SNA_RELEASE_NO_SPLASH).sna

tests: $(BIN)/$(SNA_TESTS).sna

DEBUG_FLAGS= 
# -DINVINCIBLE 
# -DDIRECT_DRAW  
# -DIGNORE_VSYNC 
# -DAUTO_FLUSH 
# -DPAUSEABLE 
# -DNO_SHIELDS 
# -DINVINCIBLE 

TEST_FLAGS=-DTEST_COIN_SECTION
#-DTEST_DEMOS
#-DTEST_SPLASH_SCREEN 

BUILD_FLAGS= 
#-Wfake

$(BIN)/$(SNA_DEBUG).sna: $(BIN) *.asm */*.asm Makefile
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-$(SYMBOLS_SUFFIX).txt \
           --lst=$(basename $@)-$(LISTING_SUFFIX).txt \
           -DDEBUG \
           $(DEBUG_FLAGS) \
		   $(BUILD_FLAGS) \
           $(MAIN_ASM).asm

$(BIN)/$(SNA_RELEASE).sna: $(BIN) *.asm */*.asm Makefile
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-$(SYMBOLS_SUFFIX).txt \
           --lst=$(basename $@)-$(LISTING_SUFFIX).txt \
		   $(BUILD_FLAGS) \
           $(MAIN_ASM).asm

$(BIN)/$(SNA_RELEASE_NO_SPLASH).sna: $(BIN) *.asm */*.asm Makefile
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-$(SYMBOLS_SUFFIX).txt \
           --lst=$(basename $@)-$(LISTING_SUFFIX).txt \
		   -DNO_SPLASH_SCREEN \
		   $(BUILD_FLAGS) \
           $(MAIN_ASM).asm

$(BIN)/$(SNA_TESTS).sna: $(BIN) *.asm */*.asm Makefile
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-$(SYMBOLS_SUFFIX).txt \
           --lst=$(basename $@)-$(LISTING_SUFFIX).txt \
           -DDEBUG \
		   $(TEST_FLAGS) \
		   $(BUILD_FLAGS) \
           tests/$(SNA_TESTS).asm

sprites:: 
	$(DOTNET) run --project $(MKSPRITES_PROJ) -- $(SPRITES_SRC) $(SPRITES_OUT) 

clean: clean-$(OS)

clean-Windows_NT:
	rmdir /S /Q $(BIN) $(SPRITES_OUT)

clean-Linux:
	rm -r $(BIN) $(SPRITES_OUT)

run-cspect-debug: debug
	$(CSPECT) $(CSPECT_FLAGS) $(BIN)/$(SNA_DEBUG).sna 

run-cspect-release: release
	$(CSPECT) $(CSPECT_FLAGS) $(BIN)/$(SNA_RELEASE).sna 

run-cspect-release-no-splash: no-splash
	$(CSPECT) $(CSPECT_FLAGS) $(BIN)/$(SNA_RELEASE_NO_SPLASH).sna 

run-mame-debug: debug
	$(MAME) $(MAME_FLAGS) -dump $(BIN)/$(SNA_DEBUG).sna 

run-mame-release: release
	$(MAME) $(MAME_FLAGS) -dump $(BIN)/$(SNA_RELEASE).sna 

run-cspect-tests: tests
	$(CSPECT) $(CSPECT_FLAGS) $(BIN)/$(SNA_TESTS).sna 
