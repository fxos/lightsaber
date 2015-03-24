#!/bin/bash
if [[ ! -d "$B2G_PATH" ]]; then
  B2G_PATH=../B2G
fi

if [[ -z "$GAIA_DEV_PIXELS_PER_PX" ]]; then
  GAIA_DEV_PIXELS_PER_PX=2.25
fi

make install
make sync
GAIA_DEV_PIXELS_PER_PX=$GAIA_DEV_PIXELS_PER_PX make shallow
rm -rf $B2G_PATH/gaia
cp -r gaia $B2G_PATH/gaia
