# Analysis Scripts Documentation

This folder has 5 notebooks that handle the MEG and behavioral data analysis for our visual-motor learning study. Each notebook serves a specific purpose in the analysis pipeline.

---

## 1. figures.ipynb
**What it does**: Creates all the behavioral plots for publications/presentations

**Data needed**: 
- `../children_data/*.mat` files - behavioral results for child participants
- `../adult_data/*.mat` files - behavioral results for adult participants

Each .mat file should contain:
- `EA` - error angle data (70 values, one per trial)
- `meanRT` - mean response times (at least 3 values for baseline/early/late learning phases)  
- `meanMT` - mean movement times (at least 3 values for baseline/early/late learning phases)

This notebook makes several different versions of the same data - line plots, bar charts, and violin plots. The main things it plots are:

**Error angles over time**: Shows how participants improve across 70 trials, split into 3 phases (baseline, early learning, late learning). You can see the classic learning curve where errors start high and decrease.

**Response/movement times**: Compares how quickly children vs adults react and move during the different learning phases. Response time is decision-making speed, movement time is actual motor execution speed.

The plots look ready with proper error bars, individual data points overlaid on group means, and statistical significance markers. There's a lot of matplotlib customization code to make everything look clean.

---

## 2. moprh_to_fsavg.ipynb  
**What it does**: Takes individual MEG source data and morphs it all to fsaverage space so we can compare across participants

**Data needed**:
- Individual MRI data in `../MRI/vml_mri_XXX/` folders (one per participant) 
- Each MRI folder needs:
  - `bem/vml_mri_XXX-ico-5-src.fif` (surface source space)
  - `mri/aseg.mgz` (segmented brain for volume sources)
- MEG data in `../MEG/vml_meg_XXX/` folders with:  
  - `XXX-cerebellar-fw-solution-run.fif` (forward solutions)
  - `DS_XXX_cond-run X-stc.h5` files (source time courses for each condition)
- fsaverage template brain (gets created if not present)

The big problem with MEG source analysis is that everyone's brain is different, so you can't directly compare activation locations across people. This notebook solves that by transforming everything to a standard brain template (fsaverage).

The tricky part is we want both surface (cortical) and volume (cerebellar) sources in the same analysis. Most MEG studies only use surface sources, but we care about the cerebellum which requires volume sources.

**What it actually does**:
1. Sets up a "mixed" source space for fsaverage (surface + cerebellum volume)
2. For each participant, calculates how to transform their brain to fsaverage
3. Applies this transformation to all their source time courses  
4. Averages the morphed data within each group (kids vs adults)
5. Creates brain plots to visualize the results

The notebook generates a lot of intermediate files and has some redundant plotting cells (cells 9-13 are basically the same thing for different conditions). The final cells convert everything to NIfTI format which other neuroimaging tools can read.

---

## 3. plotting_brain_activations.ipynb
**What it does**: Makes nice brain plots from the MEG source data

**Data needed**:
- Group-averaged morphed STCs from the previous notebook: 
  - `../MEG/adult_morphed_averaged/VML_adult_morphed-averaged_DS_run X-stc.h5`
  - `../MEG/child_morphed_averaged/VML_child_morphed-averaged_DS_run X-stc.h5`
- fsaverage brain template files:
  - `../MRI/fsaverage/bem/fsaverage-mixed-src.fif` (source space)
  - `../MRI/fsaverage/mri/T1.mgz` (anatomical image)

This is a shorter notebook that focuses on visualization. It takes the morphed/averaged source data and converts it to standard neuroimaging formats that other tools can read.

The main things it does:
- Converts MNE source estimates to NIfTI files (the standard brain imaging format)
- Finds the peak activation locations and times
- Makes orthogonal brain slice plots showing where activation is strongest
- Plots time courses of activation at the peak voxels

It's basically for quality checking and making figures. You can see if the morphing worked properly and get a sense of where and when brain activity is happening. The plots show brain slices (sagittal, coronal, axial) with activation overlaid on anatomical images.

---

## 4. stats-R.ipynb
**What it does**: Runs the main statistical tests in R (ANOVAs, post-hoc tests, Bayesian analysis)

**Data needed**: Same as figures.ipynb
- `adult_data/*.mat` and `children_data/*.mat` files with `meanRT` and `meanMT` variables

This notebook does the "real" statistics. It's using R because the mixed-effects ANOVA packages there are more mature than Python ones.

**Key analyses**:
1. **Mixed-effects ANOVA** for response time and movement time
   - Between-subjects factor: Group (kids vs adults)  
   - Within-subjects factor: Block (baseline, early learning, late learning)
   - Tests if groups differ overall, if performance changes across blocks, and if the change pattern differs by group

2. **Bayesian ANOVA** - gives you Bayes factors instead of p-values, tells you how strong the evidence is for each effect

3. **Post-hoc comparisons** - figures out exactly where the significant differences are (which groups/blocks differ from which)

The notebook has some redundant cells that test slightly different ways of running the same analyses. The key results are the mixed-effects models that account for the fact that each participant contributes multiple data points (repeated measures design).

---

## 5. stats.ipynb  
**What it does**: Python version of the stats - same analyses as the R notebook but in Python

**Data needed**: Same .mat files as the other notebooks

I basically rewrote the R statistical analysis in Python using pingouin and statsmodels. It does the same mixed-effects ANOVAs and post-hoc tests, just with different packages.

Main advantage of the Python version is it integrates better with the plotting notebooks - you can run stats and immediately make plots in the same environment. The R version is more statistically rigorous (R's mixed-effects packages are better), but this one is more convenient if you're doing everything in Python.

Results should be nearly identical between the two approaches. I included multiple comparison corrections (FDR and Bonferroni) and proper effect size calculations.

---

**File structure you need**:
```
../
├── children_data/
│   ├── VML_MEG_002_Final_Results.mat
│   ├── VML_MEG_003_Final_Results.mat
│   └── ...
├── adult_data/
│   ├── VML_MEG_011_Final_Results.mat  
│   ├── VML_MEG_012_Final_Results.mat
│   └── ...
├── MRI/
│   ├── vml_mri_002/bem/... (individual brain files)
│   ├── vml_mri_003/bem/...
│   └── fsaverage/... (template brain)
└── MEG/
    ├── vml_meg_002/... (individual MEG source files)
    ├── vml_meg_003/...
    └── (group averaged folders get created)
```
