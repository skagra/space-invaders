ASM=sjasmplus
BIN=bin

CSPECT=CSpect.exe
CSPECT_FLAGS=+tv -w2 -fps -w4 -sound -analytics

MAME=mame.exe
MAME_FLAGS=spectrum -ui_active -effect scanlines -ka -waitvsync -aspect 7:3

SYMBOLS_SUFFIX=symbols
LISTING_SUFFIX=listing

MAIN_ASM=main

SNA_STEM=space-invaders
SNA_DEBUG=$(SNA_STEM)-debug
SNA_RELEASE=$(SNA_STEM)-release
SNA_RELEASE_NO_SPLASH=$(SNA_STEM)-release-no-splash
SNA_TESTS=tests

SPRITES_SRC=sprites_source
SPRITES_OUT=sprites

DOTNET=dotnet
MKSPRITES_PROJ=../shift-sprites
