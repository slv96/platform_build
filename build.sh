#!/bin/bash

# ---------------------------------------------------------
# >>> Init Vars
  HOMEDIR=${PWD}
  # JOBS=`cat /proc/cpuinfo | grep processor | wc -l`;
  # If you uncomment the "JOBS" var make sure you comment the 
  # "JOBS" var down below in the build config
# ---------------------------------------------------------

# ---------------------------------------------------------
# >>> AOSP 4.3 for S4 (i9505)
# >>> Copyright 2013 broodplank.net
# >>> REV3
# ---------------------------------------------------------

# ---------------------------------------------------------
# >>> Check for updates before starting?
#
  CHECKUPDATES=0        # 0 to disable, 1 for repo sync
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
  MAKEPARAM=""           # Additional make parameter, for example
#                          '-k LOCAL_MODULE_TAGS:=optional' 
# ---------------------------------------------------------

export USEROLD=`whoami`;
export ULENGTH=`expr length ${USEROLD}`
if [[ ${ULENGTH} -gt 9 ]]; then
	clear
	echo
	echo
	echo "----------------------------------------"
	echo "-         AOSP 4.3 FOR I9505           -"
	echo "----------------------------------------"
	echo
	echo "Your username seems to exceed the max of 9 characters (${ULENGTH} chars)"
        echo "Due to a temp issue with bionic the max amount of characters is limited."
        echo "If the limit is exceeded the camera refuses to take pictures"
	echo 
	echo "Do you want to pick a new username right now that's below 9 chars? ( y / n )"
	read choice
	echo
	if [[ ${choice} == "n" ]]; then
		echo "Taking pictures with camera won't work, you're warned!"
		echo
		echo "Continuing..."
	else
		echo "New username:"
		read username
		export USER=${username}
		echo
		echo "Replacing current username ${USEROLD} with new username ${choice}"
		echo	
	fi;
fi;


. build/envsetup.sh
clear


echo "----------------------------------------"
echo "-       AOSP 4.3 for S4 (i9505)        -"
echo "----------------------------------------"
echo
echo " >>> Choosing jfltexx"

lunch full_jfltexx-userdebug
clear

echo ${TARGET_PRODUCT} | sed -e 's/full_//g' > ./currentdevice
export DEVICE=`cat ./currentdevice`;
rm -f ./currentdevice
TARGETDIR=${HOMEDIR}/out/target/product/${DEVICE}



ShowMenu () {
clear
echo "----------------------------------------"
echo "-       AOSP 4.3 for S4 (i9505)        -"
echo "-         www.broodplank.net           -"
echo "----------------------------------------"
echo
echo " Building in general:"
echo
echo "  [1] Synchronize repositories with upstream"
echo "  [2] Compile ROM"
echo "  [3] Compile Kernel"
echo "  [4] Make OTA Package of target files"
echo
echo " Cleaning presets: "
echo
echo "  [5] Soft Clean (device/common app intermediates)"
echo "  [6] Mediocre Clean (device/common app/java intermediates)"
echo "  [7] Scrub it like you mean it (device/common app/java/shared intermediates)"
echo "  [8] Black Hole (rm -Rf out)"
echo
echo " Help and hints: "
echo
echo "  [9] Unstucking compilation process"
echo "  [0] QuickCleaner reference"
echo
echo "  [x] Exit"
echo


}

while [ 1 ]
do
ShowMenu
read CHOICE
case "$CHOICE" in

"1")
clear
echo "----------------------------------------"
echo "- Synchronizing repos with upstream... -"
echo "----------------------------------------"
repo sync
clear
;;


"2")
clear
echo
echo "----------------------------------------"
echo "-  Compiling AOSP 4.3 for S4 (i9505)   -"
echo "-  Number of simultaneous jobs: ${JOBS}      -"
echo "----------------------------------------"
echo
busybox sleep 1
echo "Building!"
echo
make -j${JOBS} ${MAKEPARAM}
if [ -e ${PWD}/out/target/product/${DEVICE}/installed-files.txt ]; then
   echo "Compiling has probably succeeded!"
   exit
else
   echo " >>> Compilation aborted!"
   echo 
   echo "Please check the log for errors that may have halted the process"
   echo "If you cannot find any error because the log is to large, rerun"
   echo "the process and use no '-j'"
   echo
fi;
;;


"3")
clear
echo
echo "----------------------------------------"
echo "-      Compiling AOSP 4.3 Kernel       -"
echo "-  Number of simultaneous jobs: ${JOBS}      -"
echo "----------------------------------------"
echo
busybox sleep 1
echo "----------------------------------------"
echo "-       Compiling AOSP 4.3 Kernel      -"
echo "-  Number of simultaneous jobs: ${JOBS}      -"
echo "----------------------------------------"
echo
make bootimage -j${JOBS}
echo	
echo
if [ -e ${PWD}/out/target/product/${DEVICE}/boot.img ]; then
   echo "Compiling has probably succeeded!"
   exit
else
   echo " >>> Compilation aborted!"
   echo 
   echo "Please check the log for errors that may have halted the process"
   echo "If you cannot find any error because the log is to large, rerun"
   echo "the process and use no '-j'"
   echo
fi;
;; 

"4")
echo "---------------------------------------------"	
echo "- CWM Zip creation process started..        -"
echo "- Target: out/target/product/jfltexx/       -"
echo "---------------------------------------------"
make otapackage -j ${JOBS}
if [ -e ${PWD}/out/target/product/${DEVICE}/full_${DEVICE}-ota-eng-${USER}.zip ]; then
   echo "OTA Package has been built"
else
   echo "Something gone wrong.."
fi;
;;


"5")
echo "Performing Soft Clean..."
rm -Rf ${PWD}/out/target/product/${DEVICE}/obj/APPS
rm -Rf ${PWD}/out/target/product/common/obj/APPS
echo "Done!"
;;

"6")
echo "Performing Mediocre Clean..."
rm -Rf ${PWD}/out/target/product/${DEVICE}/obj/APPS
rm -Rf ${PWD}/out/target/product/common/obj/APPS
rm -Rf ${PWD}/out/target/product/${DEVICE}/obj/JAVA_LIBRARIES
rm -Rf ${PWD}/out/target/product/common/obj/JAVA_LIBRARIES
echo "Done!"
;;

"7")
echo "Performing Scrub it like you mean it..."
rm -Rf ${PWD}/out/target/product/${DEVICE}/obj/APPS
rm -Rf ${PWD}/out/target/product/common/obj/APPS
rm -Rf ${PWD}/out/target/product/${DEVICE}/obj/JAVA_LIBRARIES
rm -Rf ${PWD}/out/target/product/common/obj/JAVA_LIBRARIES
rm -Rf ${PWD}/out/target/product/${DEVICE}/obj/SHARED_LIBRARIES
echo "Done!"
;;


"8")
echo "Performing Black Hole..."
busybox sleep 2
echo "Black Hole has become unstable..."
busybox sleep 1
echo "The Black Hole forcefully starts to eat all contents in the out folder"
rm -Rf ${PWD}/out
echo "Black Hole stabalized.."
echo "Done!"
;;


"9")
echo "Function has not yet been implemented..."
;;


"0")
echo "Function has not yet been implemented..."
;;


"x")
exit
;;


esac

done
exit
