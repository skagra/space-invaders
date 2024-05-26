include build_conf/vars.mk

TARGETS = bin debug release

all: all-asm

all-asm: $(BIN) $(TARGETS)

bin: 
	mkdir $(BIN)

debug: $(BIN)/space-invaders-debug.sna

release: $(BIN)/space-invaders-release.sna

DEBUG_DEFINES=
# -DDIRECT_DRAW 
# -DIGNORE_VSYNC 
# -DAUTO_FLUSH
# -DPAUSEABLE
# -DNO_SHIELDS
# -DINVINCIBLE

$(BIN)/space-invaders-debug.sna: main.asm */*.asm
	$(ASM) 	--sld=$(basename $@).sld \
           	--fullpath \
           	--sym=$(basename $@)-symbols.txt \
           	--lst=$(basename $@)-listing.txt \
           	-DDEBUG \
			$(DEBUG_DEFINES) \
		   	main.asm

$(BIN)/space-invaders-release.sna: main.asm */*.asm
	$(ASM) --sld=$(basename $@).sld \
           --fullpath \
           --sym=$(basename $@)-symbols.txt \
           --lst=$(basename $@)-listing.txt \
           main.asm

clean-windows:
		rmdir /S /Q $(BIN)

clean-linux:
		rm -r $(BIN)

	
