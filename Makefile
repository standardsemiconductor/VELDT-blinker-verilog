all: blinker.bin

blinker.bin: blinker.asc
	icepack blinker.asc blinker.bin

blinker.asc: blinker.json blinker.pcf 
	nextpnr-ice40 --up5k --package sg48 --pcf blinker.pcf --asc blinker.asc --json blinker.json

blinker.json: blinker.v
	yosys -q -p "synth_ice40 -top top -json blinker.json -abc2" blinker.v

prog: blinker.bin
	iceprog blinker.bin

build: blinker.json

clean:
	rm -f blinker.json
	rm -f blinker.asc
	rm -f blinker.bin
	rm -f *~

.PHONY: all clean prog build
