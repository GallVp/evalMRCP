# evalMRCP

evalMRCP, which stands for evaluation of the Movement-Related Cortical Potential, is a specialised pipeline based on [visualEEG](https://github.com/GallVp/visualEEG), [emgGO](https://github.com/GallVp/emgGO), [EEGLAB](https://github.com/sccn/eeglab) and [lme4](https://cran.r-project.org/web/packages/lme4/index.html) R statistical software package. This pipeline includes all the necessary tools to process raw EEG/EMG data into MRCPs and its features. This pipeline also includes R (The R Foundation for Statistical Computing) code for performing statistical analysis on the latent variables using the linear mixed regression models. It is organised into six steps as listed below.

<ol>
    <li>
    <b>Step I:</b> In this step data is imported from different file tyes depending on the recording system and saved as <i>.mat</i> files with uniform file and variable naming.
    </li>
    <li>
    <b>Step II:</b> In this step sEMG events are detected and adjusted by visual examination using the emgGO toolbox.
    </li>
    <li>
    <b>Step III:</b> In this step epochs are first manually removed by visual inspection, then epochs with eye blinks and movement artefacts are removed using the <i>EEGLAB</i> <i>runica</i> algorithm, and finally, epochs are removed by applying a peak-peak threshold.
    </li>
    <li>
    <b>Step IV:</b> In this step extra channels are removed, and latent variables are derived.
    </li>
    <li>
    <b>Step V:</b> In this step data from individual files is collated into tables in long format and exported as <i>.csv</i> files.
    </li>
    <li>
    <b>Step VI:</b> In this step statistical analysis is performed and results are plotted.
    </li>
</ol>

## Compatibility

Currently evalMRCP is being developed on MATLAB 2017b.

## Installation

As evalMRCP consists of sub-modules such as EEGLAB, the repository has to be cloned using the following command.

```
$ git clone --recurse-submodules -j8 https://github.com/GallVp/evalMRCP
```