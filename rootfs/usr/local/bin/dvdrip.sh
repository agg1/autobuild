#!/bin/sh

VIDEO_WIDTH=640
DVD_DEVICE=/dev/sr0
TWOPASSFILE=divx2pass.$$.`date +%Y%m%d%H%M%S`

script=`basename "$0"`

track="$1"
brate="$2"
name="$3"
ISO_FILE="/tmp/${name}.iso"

if [ "$track" = "" ] || [ "$brate" = "" ] || [ "$name" = "" ]; then
    echo "$script: Rip a DVD track to DIVX"
    echo "$script: Arguments <track#> <bit-rate> <output-filename> [dvd-device (or rip directory)]"
    exit 1
fi

if [ -f "$name" ]; then
    echo "$script: [$name] exists, overwriting in 3 seconds ..."
    sleep 3
    rm -f "$name"
fi

if [ "$4" != "" ]; then
    DVD_DEVICE="$4"
    if [ ! -e "$DVD_DEVICE" ]; then
        echo "$script: Can't find DVD Device (directory) [$DVD_DEVICE]"
        exit 1
    else
        echo "$script: Reading from 'DVD' [$DVD_DEVICE]"
    fi
fi

if [ ! -e "${ISO_FILE}" ] ; then
    dd if=${DVD_DEVICE} of=${ISO_FILE} bs=1M
else
    echo "WARNING: ${ISO_FILE} exists... skipping extraction from $DVD_DEVICE"
    echo "WARNING: delete ${ISO_FILE} to re-extract dvd"
fi

#mencoder dvd://$track -passlogfile $TWOPASSFILE -dvd-device "$DVD_DEVICE" -oac mp3lame -lameopts br=192 \
#    -o /dev/null -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$brate:vhq:vpass=1:vqmin=1:vqmax=31 \
#    -vf scale -zoom -xy $VIDEO_WIDTH -alang en 2>/dev/null
#
#mencoder dvd://$track -passlogfile $TWOPASSFILE -dvd-device "$DVD_DEVICE" -oac mp3lame -lameopts br=192 \
#    -o "$name" -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$brate:vhq:vpass=2:vqmin=1:vqmax=31 \
#    -vf scale -zoom -xy $VIDEO_WIDTH -alang en 2>/dev/null
#
##echo "dvd://$track -passlogfile $TWOPASSFILE -dvd-device \"$DVD_DEVICE\" -oac copy \
##   -o \"$name\" -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$brate:vhq:vpass=2:vqmin=1:vqmax=31 \
##   -vf scale -zoom -xy $VIDEO_WIDTH -vf pp -alang en"

# note scale causes color space conversion to rgb which breaks color space interpretation somewhere
#mencoder dvd://$track -ovc xvid -xvidencopts bvhq=1:chroma_opt:quant_type=mpeg:bitrate=$brate \
#-vf scale=704:304 -oac mp3lame -lameopts br=192 -alang en -o "$name"

mencoder dvd://$track -passlogfile $TWOPASSFILE -dvd-device "$ISO_FILE" \
-ovc xvid -xvidencopts chroma_opt:quant_type=mpeg:bitrate=$brate:pass=1 \
-oac mp3lame -lameopts br=192 -alang en -o /dev/null

mencoder dvd://$track -passlogfile $TWOPASSFILE -dvd-device "$ISO_FILE" \
-ovc xvid -xvidencopts chroma_opt:quant_type=mpeg:bitrate=$brate:pass=2 \
-oac mp3lame -lameopts br=192 -alang en -o "$name"

if [ -f "$TWOPASSFILE" ]; then
    rm $TWOPASSFILE
fi

if [ -f "${ISO_FILE}" ]; then
    rm ${ISO_FILE}
fi

echo "Ripped track [$track] to [$name]"
