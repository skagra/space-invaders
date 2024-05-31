include build_conf/vars.mk

TARGETS = bin debug release

all: all-asm

all-asm: $(BIN) $(TARGETS)

bin: 
	mkdir $(BIN)

debug: $(BIN)/$(SNA_DEBUG).sna

release: $(BIN)/$(SNA_RELEASE).sna

DEBUG_FLAGS= -DINVINCIBLE
# -DDIRECT_DRAW 
# -DIGNORE_VSYNC 
# -DAUTO_FLUSH
# -DPAUSEABLE
# -DNO_SHIELDS
# -DINVINCIBLE

$(BIN)/$(SNA_DEBUG).sna: $(BIN) $(MAIN_ASM).asm */*.asm Makefile
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-$(SYMBOLS_SUFFIX).txt \
           --lst=$(basename $@)-$(LISTING_SUFFIX).txt \
		   -DDEBUG \
		   $(DEBUG_FLAGS) \
		   $(MAIN_ASM).asm

$(BIN)/$(SNA_RELEASE).sna: $(BIN) $(MAIN_ASM).asm */*.asm Makefile
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-$(SYMBOLS_SUFFIX).txt \
           --lst=$(basename $@)-$(LISTING_SUFFIX).txt \
           $(MAIN_ASM).asm

clean: clean-$(OS)

clean-Windows_NT:
	rmdir /S /Q $(BIN)

clean-Linux:
	rm -r $(BIN)

run-cspect-debug: debug
	$(CSPECT) $(CSPECT_FLAGS) $(BIN)/space-invaders-debug.sna 

run-cspect-release: release
	$(CSPECT) $(CSPECT_FLAGS) $(BIN)/space-invaders-release.sna 

run-mame-debug: debug
	$(MAME) $(MAME_FLAGS) -dump $(BIN)/space-invaders-debug.sna 

run-mame-release: release
	$(MAME) $(MAME_FLAGS) -dump $(BIN)/space-invaders-release.sna 
