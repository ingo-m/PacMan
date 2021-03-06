#!/bin/sh


################################################################################
# The purpose of this script is to perform distortion correction on opposite   #
# phase-encoding data. The input data need to be motion-corrected beforehands. #
# You may use a modified topup configuration file for better results.          #
################################################################################


echo "-Distortion correction"


#-------------------------------------------------------------------------------
# Define session IDs & paths:

# Parent directory"
strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Functional runs (input & output):
aryRun=(func_01 \
        func_02 \
        func_03 \
        func_04 \
        func_05 \
        func_06 \
        func_07 \
        func_08 \
        func_09 \
        func_10)

# Define name of configuration file:
strPathCnf="/home/john/PhD/Analysis_Scripts/Analysis_Scripts_344_06012017/Miscellaneous/PacMan/20161221_distcor_func/01_preprocessing/n_08b_highres.cnf"

# Path for 'datain' text file with acquisition parameters for topup (see TOPUP
# documentation for details):
strDatain01="/home/john/PhD/Analysis_Scripts/Analysis_Scripts_344_06012017/Miscellaneous/PacMan/20161221_distcor_func/01_preprocessing/n_08c_datain_topup.txt"

# Parallelisation factor:
varPar=10

# Path of images to be undistorted (input):
strPathFunc="${strPathParent}func_regWithinRun/"

# Path of opposite-phase encode run (input):
strPathOpp="${strPathParent}func_regWithinRun_op/"

# Path for merged 'functional' and opposite-phase encode run (intermediate
# output):
strPathMerged="${strPathParent}func_merged/"

# Path for bias field (intermediate output):
strPathRes01="${strPathParent}func_distcorField/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Preparations

echo "---Preparations"

# Number of runs:
varNumRun=${#aryRun[@]}
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Create 5-volume segments from 'normal' functional images:

echo "---Create 5-volume segments from 'normal' functional images"
date

for idxRun in $(seq 0 $((${varNumRun} - 1)))
do

	fslroi \
	${strPathFunc}${aryRun[idxRun]} \
	${strPathFunc}${aryRun[idxRun]}_vol5 \
	0 \
	5 &

	# Check whether it's time to issue a wait command (if the modulus of the
	# index and the parallelisation-value is zero):
	if [[ $((${idxRun} + 1))%${varPar} -eq 0 ]]
	then
		# Only issue a wait command if the index is greater than zero (i.e.,
		# not for the first segment):
		if [[ ${idxRun} -gt 0 ]]
		then
			wait
			echo "------Progress: $((${idxRun} + 1)) runs out of" \
				"${varNumRun}"
		fi
	fi

done
wait
date
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Merge 'normal' and opposite-phase encode images:

echo "---Merge 'normal' and opposite-phase encode images"
date

for idxRun in $(seq 0 $((${varNumRun} - 1)))
do

	#echo "------Run: ${aryRun[idxRun]}" &

	fslmerge \
	-t \
	${strPathMerged}${aryRun[idxRun]} \
	${strPathFunc}${aryRun[idxRun]}_vol5 \
	${strPathOpp}${aryRun[idxRun]} &

	# Check whether it's time to issue a wait command (if the modulus of the
	# index and the parallelisation-value is zero):
	if [[ $((${idxRun} + 1))%${varPar} -eq 0 ]]
	then
		# Only issue a wait command if the index is greater than zero (i.e.,
		# not for the first segment):
		if [[ ${idxRun} -gt 0 ]]
		then
			wait
			echo "------Progress: $((${idxRun} + 1)) runs out of" \
				"${varNumRun}"
		fi
	fi

done
wait
date
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Calculate field maps:

echo "------Calculate field maps"
date

# Parallelisation over runs:
for idxRun in $(seq 0 $((${varNumRun} - 1)))
do

	#echo "------Run: ${aryRun[idxRun]}" &

	topup \
	--imain=${strPathMerged}${aryRun[idxRun]} \
	--datain=${strDatain01} \
	--config=${strPathCnf} \
	--out=${strPathRes01}${aryRun[idxRun]} &

	# Check whether it's time to issue a wait command (if the modulus of the
	# index and the parallelisation-value is zero):
	if [[ $((${idxRun} + 1))%${varPar} -eq 0 ]]
	then
		# Only issue a wait command if the index is greater than zero (i.e.,
		# not for the first segment):
		if [[ ${idxRun} -gt 0 ]]
		then
			wait
			echo "------Progress: $((${idxRun} + 1)) runs out of" \
				"${varNumRun}"
		fi
	fi
done
wait
date
#-------------------------------------------------------------------------------
