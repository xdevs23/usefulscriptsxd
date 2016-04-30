#!/bin/bash

LUNCH_DEVICE=""
MODULE_NAME=""

echo "Configuring..."
source configure.sh $1

echo "Starting build..."
CRTDIR=$(pwd)
croot
if [ -z "$TARGET_PRODUCT" ]; then lunch $LUNCH_DEVICE; fi
if [ "$1" != "noclean" ]; then make -j4 clean; fi
make -j32 $MODULE_NAME
cd $CRTDIR

echo "Build finished"
