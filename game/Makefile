include build_conf/vars.mk

TARGETS = bin debug release

all: all-asm

all-asm: $(BIN) $(TARGETS)

bin: 
	mkdir $(BIN)

debug: $(BIN)/space-invaders-debug.sna

release: $(BIN)/space-invaders-release.sna

DEBUG_DEFINES=-DDEBUG 
# -DDIRECT_DRAW 
# -DIGNORE_VSYNC 
# -DAUTO_FLUSH
# -DPAUSEABLE
# -DNO_SHIELDS
# -DINVINCIBLE

$(BIN)/space-invaders-debug.sna: $(BIN) main.asm */*.asm
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-symbols.txt \
           --lst=$(basename $@)-listing.txt \
		   $(DEBUG_DEFINES) \
		   main.asm

$(BIN)/space-invaders-release.sna: $(BIN) main.asm */*.asm
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-symbols.txt \
           --lst=$(basename $@)-listing.txt \
           main.asm

clean: clean-$(OS)

clean-Windows_NT:
	rmdir /S /Q $(BIN)

clean-Linux:
	rm -r $(BIN)

CSPECT_FLAGS=+tv -60 -w2 -fps -w4 -sound -analytics

run-cspect-debug: debug
	CSpect.exe $(CSPECT_FLAGS) $(BIN)/space-invaders-debug.sna 

run-cspect-release: release
	CSpect.exe $(CSPECT_FLAGS) $(BIN)/space-invaders-release.sna 