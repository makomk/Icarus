#!/bin/sh
set -e
PREFIX="cm1out/shortfin_dcmwd2"
VARIANTS="test_140 test_150 test_160 test_170_overclock test_180_overclock test_190_overclock test_200_overclock"

egrep -v 'COMP "([RT]xD|extminer_[rt]xd<.>|dip<0>)" LOCATE' fpgaminer_top.pcf > "$PREFIX.pcf"
cp fpgaminer_top.ncd "$PREFIX.ncd"
fpga_edline -e -p edit_pinout.scr "$PREFIX.ncd" "$PREFIX.pcf"
par -ol high -xe n -k "$PREFIX.ncd" "$PREFIX"_par.ncd "$PREFIX.pcf"
mv "$PREFIX"_par.ncd "$PREFIX.ncd"

for VARIANT in $VARIANTS; do
    cp "$PREFIX.ncd" "$PREFIX"_tmp.ncd
    cp "$PREFIX.pcf" "$PREFIX"_tmp.pcf
    fpga_edline -e -p "edscripts/$VARIANT.scr" "$PREFIX"_tmp.ncd "$PREFIX"_tmp.pcf
    bitgen -w "$PREFIX"_tmp.ncd "$PREFIX"_"$VARIANT".bit "$PREFIX"_tmp.pcf
    rm "$PREFIX"_tmp.ncd "$PREFIX"_tmp.pcf
done
