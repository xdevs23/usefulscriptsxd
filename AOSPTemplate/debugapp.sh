#/bin/sh

APP_NAME=""
LOCL_FN="app.apk"
START_ACTIVITY=".MainActivity"
OPEN_ACTIVITY=1
START_LOGCAT=1
APP_TAG="$APP_NAME"
DBGAPKPATH="$OUT/system/app/$APP_NAME/$APP_NAME.apk"
ADBARGS=""
CONTINUEXEC=true
COMPILEAPP=true
APPK="com.example.app"
BUILD_ARGS=""

if [ "$1" == "--adbArgs" ]; then
  ADBARGS="$2 $3 $4 $5 $6"
  COMPILEAPP=true
fi

if [ "$1" == "noclean" ]; then
  BUILD_ARGS="$BUILD_ARGS noclean"
  COMPILEAPP=true
fi

if [ -z "$1" ]; then source buildDebugApp.sh $BUILD_ARGS
elif [ COMPILEAPP ]; then source buildDebugApp.sh $BUILD_ARGS; fi

echo "Requesting root..."
adb root

if [ "$1" == "-l" ]; then
  adb logcat -v tag -s $APP_TAG:*
  CONTINUEXEC=false
elif [ "$1" == "--cleardata" ]; then
  adb shell pm clear $APPK
  CONTINUEXEC=false
elif [ "$1" == "-i" ]; then
  adb push $DBGAPKPATH /sdcard/$LOCL_FN
  adb shell pm set-install-location 1
  adb shell pm install -rdtf /sdcard/$LOCL_FN
  CONTINUEXEC=false
elif [ "$1" == "--start" ]; then
  if [ $OPEN_ACTIVITY = 1 ]; then
    adb shell am start -n $APPK/$START_ACTIVITY
  else echo "Opening activity not supported."
  fi
  CONTINUEXEC=false
elif [ "$1" == "--uninstall" ]; then
  adb shell pm uninstall $APPK
  CONTINUEXEC=false
elif [ "$1" == "--reinstall" ]; then
  adb shell pm uninstall $APPK
  adb push $DBGAPKPATH /sdcard/$LOCL_FN
  adb shell pm set-install-location 1
  adb shell pm install -rdtf /sdcard/$LOCL_FN
  CONTINUEXEC=false
fi

if [ CONTINUEXEC ]; then
  adb $ADBARGS push $DBGAPKPATH /sdcard/$LOCL_FN
  adb $ADBARGS root>/dev/null
  adb $ADBARGS wait-for-device
  adb $ADBARGS shell pm set-install-location 1
  adb $ADBARGS shell pm install -rdtf /sdcard/$LOCL_FN
  if [ OPEN_ACTIVITY = 1]; then
    adb $ADBARGS shell am start -n $APPK/$START_ACTIVITY
  fi
  if [ START_LOGCAT  = 1]; then
    if [ "$1" == "--grp" ]; then adb $ADBARGS logcat -v tag -s $APP_TAG:* | grep $2
    else adb $ADBARGS logcat -v tag -s $APP_TAG:*
    fi
  fi
fi
