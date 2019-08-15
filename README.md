# PacMan
Analysis pipeline for the PacMan project.

The analysis pipeline makes use of several MRI software packages (such as SPM and FSL for preprocessing, and CBS tools for cortical depth sampling). In order to facilitate reproducibility, the entire analysis was containerised using docker. Because of licensing issues, the docker images with the third-party software cannot be directly made available. However, the docker files and detailed instructions for the creation of the docker images can be found [here](https://github.com/ingo-m/PacMan/tree/master/docker).

If you would like to reproduce the analysis, the first step will be to create the docker images (which provide an exact copy of the system environment that was used to conduct the published analysis). There are two docker images, one for the main analysis (motion correction, distortion correction, GLM fitting; named `dockerimage_pacman_jessie`), and another one for the depth sampling (named `dockerimage_cbs`). Detailed instructions on how to create the docker images can be found [here](https://github.com/ingo-m/PacMan/blob/master/docker/Info_Prepare_PacMan_Image_Jessie.txt) and [here](https://github.com/ingo-m/PacMan/blob/master/docker/Info_Prepare_CBS_Image.txt).

Once you set up the docker images, the analysis can be run automatically. For each subject, there is one parent script for the main analysis (e.g. [metascript_01.sh](http://github.com/ingo-m/PacMan/blob/master/analysis/20180118/metascript_01.sh) for subject 20180118) and a separate script for the depth sampling (e.g. [metascript_03.sh](https://github.com/ingo-m/PacMan/blob/master/analysis/20180118/metascript_03.sh)). The only manual adjustments you should have to perform to reproduce the analysis is to change the file paths in the first section of these scripts (`pacman_anly_path` is the parent directory containing the analysis code, i.e. the git repository, and `pacman_data_path` is the parent directory containing the MRI data). The main analysis (`metascript_01.sh`) should take about 24 h per subject on a workstation with 12 cores, and the depth sampling (`metascript_02.sh`) about 2 h. The analysis can be run on consumer-grade hardware, but some parts of the analysis may not run with less than 16 GB of RAM (recommended: 32 GB).

Visualisations (e.g. cortical depth profiles and signal timecourses) and group-level statistical tests are implemented in a [separate repository](https://github.com/ingo-m/py_depthsampling/tree/PacMan).
