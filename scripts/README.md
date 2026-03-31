# Scripts

This folder keeps the main R scripts used in the project.

The filenames were cleaned for GitHub readability, but the logic comes from the original course project materials.

## Script Order

### 1. `01_airbnb_data_cleaning_eda_wenzhuo.R`
This script covers the earlier-stage work shown in the project materials, including:
- loading the raw dataset
- duplicate checks
- price and service fee cleaning
- missing value handling
- category cleanup
- basic exploratory analysis
- writing a cleaned CSV output (`Airbnb.csv`)

### 2. `02_airbnb_text_modeling_random_forest_cheng.R`
This script covers the later-stage analytics work that I mainly focused on, including:
- feature engineering
- correlation checks
- clustering and mapping
- house rules tokenization
- sentiment analysis
- LDA topic modeling
- random forest modeling
- variable importance
- partial dependence review
- optional cross-validation code

## Local Data Path

Both scripts should point to:

`data/Airbnb_Open_Data.csv`

## Notes

- The final report appendix only included Wenzhuo's code.
- My R code was provided separately in the project materials in this chat.
- The dashboard source file itself was not uploaded in this chat, so this repo keeps screenshots instead of the original dashboard workbook.
- The scripts were kept close to the original project materials, so they are project workflows rather than a polished one-click pipeline.
- Script 1 writes a cleaned file named `Airbnb.csv` using a relative path, so running it from the repo root creates that file at the top level.
- In Script 2, the held-out modeling step uses training-set means for numeric imputation, and the optional cross-validation block stays on the training split.

## Package List

See [packages-used.md](packages-used.md).
