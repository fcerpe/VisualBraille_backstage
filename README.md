# Visual Braille Backstage Code

All the functions stored here were made in support of the three projects of my PhD: 
- Visual Braille Expertise (fRMI experiment)
- Visual Braille Training (online behavioural experiment)
- Visual Braille Silico (DNN experiment)

For the actual experiments, refer to the reposiotries linked above.

## Details of the subfolders 

### Resources
Here you can find drafts of code that were later modified to make the functions that I actually used to make, select, modify the stimuli.


### VBE_first_design


### VBE_final_design
Design used in the fMRI experiment. This subfolder has the scripts to make the stimuli used in the scanner

#### Folders
- datasets: french lexicon project, lexique 3.83, lexique-infra 1.11. All thses datasets are in forms of tables to be read by the scripts, and possibly contain only a selection of columns relevant for the extraction of features.

- mvpa_categories: scripts to make the final seelction of 12 words, 12 pseudo-words, 12 non-words, 12 fake script strings. Contains scripts to **choose** the stimuli, to **make** the images, as well as controls on what was picked (e.g. balancing the frequency of consonants in the non-words).  
  Important files: 
  - ffs_letters contains the manually created fake script letters, then assembled into fake words.
  - stimuli_imgs contains the final stimuli.

- post_selection: scripts to choose the stimuli for the localizer exepriment, after a manual selection of words and line-drawings available. 


### VBE_reading_list
List of stimuli to be presented to expert participants prior to their fMRI experiment. Used as a measure of expertise


### VBT_stimuli_dutch


### VBT_stimuli_french


### VBS_stimuli


## Contacts
I made these subfolders in different times across years of research. Some inconsistencies, differences in approaches are possible. 
This repository is not meant to be a final product, just a personal assistance.
If anythig is not clear, don't hesitate to let me know.

Filippo Cerpelloni  
filippo.cerpelloni [at] gmail.com