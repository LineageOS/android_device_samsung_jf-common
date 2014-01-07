#!/bin/bash

set -e

if [ $# -eq 0 ]; then
  SRC=adb
else
  if [ $# -eq 1 ]; then
    SRC=$1
  else
    echo "$0: bad number of arguments"
    echo ""
    echo "usage: $0 [PATH_TO_EXPANDED_ROM]"
    echo ""
    echo "If PATH_TO_EXPANDED_ROM is not specified, blobs will be extracted from"
    echo "the device using adb pull."
    exit 1
  fi
fi

# Fall-through so variable is not required, but usable
if [ -z "$DEVICE_UNIFIED" ]; then
  DEVICE_UNIFIED=$DEVICE
fi

BASE=../../../vendor/$VENDOR/$DEVICE_UNIFIED/proprietary
rm -rf $BASE/*

for FILE in `egrep -v '(^#|^$)' ../$DEVICE/device-proprietary-files.txt`; do
  echo "Extracting /system/$FILE ..."
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  FILE=${PARSING_ARRAY[0]}
  DEST=${PARSING_ARRAY[1]}
  if [ -z $DEST ]; then
    DEST=$FILE
  fi
  DIR=`dirname $FILE`
  if [ ! -d $BASE/$DIR ]; then
    mkdir -p $BASE/$DIR
  fi
  if [ "$SRC" = "adb" ]; then
    adb pull /system/$FILE $BASE/$DEST
    # if file does not exist try destination
    if [ "$?" != "0" ]; then
      adb pull /system/$DEST $BASE/$DEST
    fi
  else
    cp $SRC/system/$FILE $BASE/$DEST
    # if file does not exist try destination
    if [ "$?" != "0" ]; then
      cp $SRC/system/$DEST $BASE/$DEST
    fi
  fi
done

for FILE in `egrep -v '(^#|^$)' ../jf-common/proprietary-files.txt`; do
  echo "Extracting /system/$FILE ..."
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  FILE=${PARSING_ARRAY[0]}
  DEST=${PARSING_ARRAY[1]}
  if [ -z $DEST ]; then
    DEST=$FILE
  fi
  DIR=`dirname $FILE`
  if [ ! -d $BASE/$DIR ]; then
    mkdir -p $BASE/$DIR
  fi
  if [ "$SRC" = "adb" ]; then
    adb pull /system/$FILE $BASE/$DEST
    # if file does not exist try destination
    if [ "$?" != "0" ]; then
      adb pull /system/$DEST $BASE/$DEST
    fi
  else
    cp $SRC/system/$FILE $BASE/$DEST
    # if file does not exist try destination
    if [ "$?" != "0" ]; then
      cp $SRC/system/$DEST $BASE/$DEST
    fi
  fi
done

BASE=../../../vendor/$VENDOR/jf-common/proprietary
rm -rf $BASE/*
for FILE in `egrep -v '(^#|^$)' ../jf-common/common-proprietary-files.txt`; do
  echo "Extracting /system/$FILE ..."
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  FILE=${PARSING_ARRAY[0]}
  DEST=${PARSING_ARRAY[1]}
  if [ -z $DEST ]; then
    DEST=$FILE
  fi
  DIR=`dirname $FILE`
  if [ ! -d $BASE/$DIR ]; then
    mkdir -p $BASE/$DIR
  fi
  if [ "$SRC" = "adb" ]; then
    adb pull /system/$FILE $BASE/$DEST
    # if file does not exist try destination
    if [ "$?" != "0" ]; then
      adb pull /system/$DEST $BASE/$DEST
    fi
  else
    cp $SRC/system/$FILE $BASE/$DEST
    # if file does not exist try destination
    if [ "$?" != "0" ]; then
      cp $SRC/system/$DEST $BASE/$DEST
    fi
  fi
done

./../jf-common/setup-makefiles.sh
