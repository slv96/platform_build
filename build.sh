# Write here your pc's number of cores + number of threads
NBR="12"

# Do not edit!
echo "Rom Building Started"
. patches/patch.sh
. build/envsetup.sh
lunch full_janice-userdebug
STARTTIME=$SECONDS
make otapackage -j$NBR 
ENDTIME=$SECONDS
echo -e "\n\n = Finished in $((ENDTIME-STARTTIME)) Seconds =\n\n"
