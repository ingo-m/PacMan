#!/bin/bash


###############################################################################
# The purpose of this script is to copy the 'original' nii images, after      #
# DICOM to nii conversion, and reorient them to standard orientation. The     #
# contents of this script have to be adjusted individually for each session,  #
# as the original file names may differ from session to session.              #
###############################################################################


#------------------------------------------------------------------------------
# *** Define paths:

# Parent directory:
strPthPrnt="${pacman_data_path}${pacman_sub_id}/nii"

# BIDS directory:
strBidsDir="${pacman_data_path}BIDS/"

# 'Raw' data directory, containing nii images after DICOM->nii conversion:
strRaw="${strPthPrnt}/raw_data/"

# Destination directory for functional data:
strFunc="${strBidsDir}${pacman_sub_id_bids}/func/"

# Destination directory for same-phase-polarity SE images:
strSe="${strBidsDir}${pacman_sub_id_bids}/func_se/"

# Destination directory for opposite-phase-polarity SE images:
strSeOp="${strBidsDir}${pacman_sub_id_bids}/func_se_op/"

# Destination directory for mp2rage images:
strAnat="${strBidsDir}${pacman_sub_id_bids}/anat/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Create BIDS directory tree

# Check whether the session directory already exists:
if [ ! -d "${strBidsDir}${pacman_sub_id_bids}" ];
then
	echo "Create BIDS directory for ${strBidsDir}${pacman_sub_id_bids}"

	# Create BIDS subject parent directory:
	mkdir "${strBidsDir}${pacman_sub_id_bids}"

	# Create BIDS directory tree:
	mkdir "${strAnat}"
	mkdir "${strFunc}"
	mkdir "${strSe}"
	mkdir "${strSeOp}"
else
	echo "Directory for ${strBidsDir}${pacman_sub_id_bids} does already exist."
fi
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy functional data

fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_SERIES_010_c32 ${strFunc}func_01
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func02_FOV_RL_SERIES_012_c32 ${strFunc}func_02
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func03_FOV_RL_SERIES_014_c32 ${strFunc}func_03
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func04_FOV_RL_SERIES_022_c32 ${strFunc}func_04
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func05_FOV_RL_SERIES_024_c32 ${strFunc}func_05
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func06_FOV_RL_SERIES_026_c32 ${strFunc}func_06
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func07_FOV_RL_pRF_SERIES_028_c32_e1 ${strFunc}func_07
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy opposite-phase-polarity SE images

fslreorient2std ${strRaw}PROTOCOL_cmrr_mbep2d_se_LR_SERIES_007_c32_e1 ${strSeOp}func_00
fslreorient2std ${strRaw}PROTOCOL_cmrr_mbep2d_se_RL_SERIES_008_c32 ${strSe}func_00
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy mp2rage images

fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_015_c32 ${strAnat}mp2rage_inv1
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_016_c32 ${strAnat}mp2rage_inv1_phase
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_017_c32_e1 ${strAnat}mp2rage_pdw
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_018_c32 ${strAnat}mp2rage_pdw_phase
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_019_c32 ${strAnat}mp2rage_t1
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_020_c32 ${strAnat}mp2rage_uni
#------------------------------------------------------------------------------
