#!/bin/bash

# ---------------------------------------------------------
# >>> Init Vars
  HOMEDIR=${PWD}
  # JOBS=`cat /proc/cpuinfo | grep processor | wc -l`;
  # If you uncomment the "JOBS" var make sure you comment the 
  # "JOBS" var down below in the build config
# ---------------------------------------------------------

# ---------------------------------------------------------
# >>> AOSP S4
# >>> Copyright 2013 broodplank.net
# >>> REV1
# ---------------------------------------------------------

# ---------------------------------------------------------
# >>> Check for updates before starting?
#
  CHECKUPDATES=0        # 0 to disable, 1 for repo sync 
  MAKEPARAM=""          # set make param, like -k 
# ---------------------------------------------------------

# ---------------------------------------------------------
#
# >>> BUILD CONFIG
#
# ---------------------------------------------------------
#
# >>> Main Configuration (intended for option 6, All-In-One) 
#
  JOBS=5                 # CPU Cores + 1 (also hyperthreading)
  MAKEOTAPACKAGE=1       # Gief ZIP
# ---------------------------------------------------------


. build/envsetup.sh
clear
echo
echo
echo "----------------------------------------"
echo "-         AOSP 4.3 FOR I9505           -"
echo "----------------------------------------"
echo
echo
echo " >>> Choosing full_jfltexx-userdebug"
echo
echo
lunch full_jfltexx-userdebug
echo
echo
busybox sleep 2
clear


if [[ "$CHECKUPDATES"=="1" ]]; then

	clear
	echo "----------------------------------------"
	echo "- Syncing repositories...              -"
	echo "----------------------------------------"
	repo sync
	clear
else
	echo "Skipping repo derp"
	clear
fi

echo " "	
echo "----------------------------------------"
echo "-        Compiling AOSP 4.3            -"
echo "-  Number of simultaneous jobs: ${JOBS}      -"
echo "----------------------------------------"
echo " "
busybox sleep 1
echo "Building!"
echo " "
make -j${JOBS} ${MAKEPARAM}




if [[ "$MAKEOTAPACKAGE" == "1" ]]; then
	make otapackage -j ${JOBS}
else 
	echo "Skipping derppackage"
fi;

