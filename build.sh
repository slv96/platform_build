# Write here your pc's number of cores + number of threads
NBR="12"

# Do not edit!
echo ""
echo ""
echo "       ############################################################### "
echo "      #                       ________   _________  ________          #"
echo "      #              /\      |        | |          |        |         #"
echo "      #             /  \     |        | |          |        |         #"
echo "      #            /    \    |        | |________  |________|         #"
echo "      #           /______\   |        |          | |                  #"
echo "      #          /        \  |        |          | |                  #"
echo "      #         /          \ |________| _________| |                  #"
echo "      #                                                               #"
echo "       ############################################################### "
echo ""
echo "       ############################################################### "
echo "      #    _________  _________  _________               __    __     #"
echo "      #        |          |     |               /\      |  \  /  |    #"
echo "      #        |          |     |              /  \     |   \/   |    #"
echo "      #        |   ____   |     |____         /    \    |        |    #"
echo "      #        |          |     |            /______\   |        |    #"
echo "      #        |          |     |           /        \  |        |    #"
echo "      #     ___|          |     |_________ /          \ |        |    #"
echo "      #                                                               #"
echo "       ############################################################### "
echo ""
echo ""
. patches/patch.sh
. build/envsetup.sh
lunch full_janice-userdebug
STARTTIME=$SECONDS
make otapackage -j$NBR 
ENDTIME=$SECONDS
echo "       ############################################################### "
echo "      #                                                               #"
echo "      #                                                               #"
echo "      #                                                               #"
echo -e "                        = Finished in $((ENDTIME-STARTTIME)) Seconds ="
echo "      #                                                               #"
echo "      #                                                               #"
echo "      #                                                               #"
echo "       ############################################################### "
