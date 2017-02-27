#!/bin/sh
DEVICE=$1

[ -z "$DEVICE" -o ! -e "${DEVICE}" ] && echo "device error" && exit 1

# half speed mode off
echo -ne "\x1B\x73\x00" > "$DEVICE" 
# quality mode off, speed on
echo -ne "\x1B\x78\x00" > "$DEVICE" 
# 15cpi 0x67, 12cpi 0x4D, 10cpi 0x50
echo -ne "\x1B\x67" > "$DEVICE" 
# proportional spacing off with 15cpi
echo -ne "\x1B\x70\x00" > "$DEVICE" 
# unidirectional off
echo -ne "\x1B\x55\x00" > "$DEVICE" 
