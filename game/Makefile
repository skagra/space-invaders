include build_conf/vars.mk

TARGETS = space-invaders-debug.sna space-invaders-release.sna 

all: all-asm

all-asm: $(BIN) $(TARGETS)

bin: 
	mkdir $(BIN)

space-invaders-debug.sna: $(BIN)/space-invaders-debug.sna

space-invaders-release.sna: $(BIN)/space-invaders-release.sna

DEBUG_DEFINES=
# -DDIRECT_DRAW 
# -DIGNORE_VSYNC 
# -DAUTO_FLUSH
# -DPAUSEABLE
# -DNO_SHIELDS
# -DINVINCIBLE

$(BIN)/space-invaders-debug.sna: main.asm */*.asm
	$(ASM) 	--sld=$(BIN)/space-invaders-debug.sld \
           	--fullpath \
           	--sym=$(BIN)/space-invaders-debug-symbols.txt \
           	--lst=$(BIN)/space-invaders-debug-listing.txt \
           	-DDEBUG \
			$(DEBUG_DEFINES) \
		   	main.asm

$(BIN)/space-invaders-release.sna: main.asm */*.asm
	$(ASM) --sld=$(BIN)/space-invaders-release.sld \
           --fullpath \
           --sym=$(BIN)/space-invaders-release-symbols.txt \
           --lst=$(BIN)/space-invaders-release-listing.txt \
           main.asm

clean-windows:
		rmdir /S /Q $(BIN)

	