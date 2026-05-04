# Data Note

This project uses the Airbnb Open Data dataset from Kaggle. The public GitHub version of this repository is intended to keep the raw CSV out of version control.

## Dataset Used

- Dataset name: Airbnb Open Data
- Source: `https://www.kaggle.com/datasets/arianazmoudeh/airbnbopendata`
- Expected local filename: `Airbnb_Open_Data.csv`
- Expected local path: `data/Airbnb_Open_Data.csv`
- Raw file shape used in this project: 102,599 rows and 26 columns
- Granularity: one row per Airbnb listing record

## Main Field Groups

The project used one main listing-level table. Important field groups included:

- listing identifiers
- host information
- neighborhood and latitude/longitude fields
- room type
- price and service fee
- minimum nights
- review count and review-rate fields
- availability fields
- `house_rules` text

The target used for modeling was `number of reviews`, which was treated as a practical proxy for listing engagement.

## Reproduction Note

To reproduce the R scripts locally:

1. Download the dataset from Kaggle.
2. Place the CSV at `data/Airbnb_Open_Data.csv`.
3. Run the scripts from the repository root so the relative data path resolves correctly.

The raw CSV may exist in a local working copy for reproduction, but it is ignored by `.gitignore` and is not part of the tracked public project files.

## Data Limitations

- `number of reviews` is only a proxy for engagement. It does not directly measure bookings, revenue, occupancy, or guest satisfaction.
- A separate formal data dictionary is not included in this repository.
- The raw dataset contains missing values and duplicate records that need to be handled before analysis.
- Many `house_rules` values are missing or may contain data artifacts, so text-analysis results should be interpreted carefully.
- The project uses public, observational data, so it should not be used to make causal claims.
