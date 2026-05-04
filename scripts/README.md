# Scripts

This folder keeps the main R scripts used in the project. The scripts were kept close to the original course project materials, so they are analysis workflows rather than a polished one-click pipeline.

## Script Order

### 1. `01_airbnb_data_cleaning_eda_wenzhuo.R`

This script covers earlier-stage cleaning and EDA work from the original project materials, including:

- loading the raw dataset
- checking duplicate rows
- cleaning price and service-fee fields
- handling missing values
- standardizing selected category values
- removing the mostly empty `license` field
- converting date fields
- writing a cleaned CSV output named `Airbnb.csv`

This script is associated with the earlier project workflow and the final report appendix.

### 2. `02_airbnb_text_modeling_random_forest_cheng.R`

This script covers the later-stage analytics work that I mainly focused on, including:

- feature engineering
- correlation checks
- k-means clustering and mapping
- house-rules tokenization
- sentiment analysis with the Bing lexicon
- LDA topic modeling
- random forest regression for `number.of.reviews`
- variable importance review
- partial dependence review
- optional cross-validation code

## Local Data Path

Both scripts expect the dataset at:

```text
data/Airbnb_Open_Data.csv
```

The raw CSV is ignored in the public GitHub version. See [../data/README.md](../data/README.md) for the dataset source and reproduction note.

## Modeling Notes

- The modeling target is `number.of.reviews`, used as a proxy for listing engagement.
- The random forest workflow combines structured fields with sentiment and topic features from `house_rules`.
- Reported project metrics were MAE 19.18, RMSE 35.36, and R-squared 0.349.
- These metrics show moderate predictive signal, not production-ready performance.
- The optional cross-validation block is included in the script, but confirmed cross-validation results are not included in the project documentation.
- Variable importance and partial dependence should be interpreted as model-based patterns, not causal proof.

## Reproduction Notes

- Run scripts from the repository root so relative paths work.
- Script 1 writes `Airbnb.csv` at the repository root when run from the root folder.
- The dashboard source file itself is not included here, so this repository keeps screenshots instead of the original live dashboard workbook.
- The scripts do not represent a production pipeline, deployed model, or automated reporting system.

## Package List

See [packages-used.md](packages-used.md).
