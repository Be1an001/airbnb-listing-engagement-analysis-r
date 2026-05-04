# Airbnb Listing Engagement Analysis in R

This repository is a public portfolio version of a two-person ALY6110 course project at Northeastern University. The project analyzes NYC Airbnb listing data to understand which structured listing fields and house-rules text features are associated with higher review volume.

The project uses `number of reviews` as a practical proxy for listing engagement. It does not directly measure bookings, revenue, occupancy, conversion, or guest satisfaction.

## Project Type / Status / Tools

- Project type: R statistical / business analytics project with NLP and random forest modeling
- Course context: ALY6110: Data Management and Big Data, Fall 2024
- Status: coursework / case study with portfolio documentation
- Main tools: R, tidyverse, dplyr, tidyr, ggplot2, tidytext, topicmodels, randomForest, caret, pdp, leaflet
- Main artifacts: R scripts, final report PDF, final presentation PDF, selected static visuals, and a shorter portfolio PDF

This is not a production prediction system, deployed app, live dashboard repo, SQL project, GenAI project, or MLOps project.

## Business Problem

Airbnb hosts and analysts may want to understand why some listings receive more guest attention than others. In this project, review count was used as a simple engagement proxy to study patterns across price, availability, minimum nights, room type, location, and house-rules text.

The analysis focuses on association and interpretation. It should not be read as proof that changing one feature will directly cause more reviews.

## Project Objective

The goal was to connect a listing-level Airbnb dataset with both structured analysis and text-based features:

- clean and inspect the raw Airbnb listing data
- summarize listing patterns by room type, neighborhood, price, and availability
- use dashboard-style visuals to make the market patterns easier to read
- process `house_rules` text into sentiment and topic features
- train a random forest regression model for review volume
- interpret which features appeared most important in the model

## Dataset

- Dataset: Airbnb Open Data
- Source: Kaggle, `https://www.kaggle.com/datasets/arianazmoudeh/airbnbopendata`
- Expected local filename: `data/Airbnb_Open_Data.csv`
- Raw data shape used in the project: 102,599 rows and 26 columns
- Granularity: one row per Airbnb listing record
- Engagement proxy: `number of reviews`

Main field groups included listing identifiers, host information, neighborhood and geo fields, room type, price and service fee, minimum nights, review fields, availability fields, and `house_rules` text.

The public GitHub version is intended to keep the raw CSV out of version control. To reproduce the scripts locally, download the dataset from Kaggle and place it at `data/Airbnb_Open_Data.csv`.

## My Role / Contribution

This was a two-person team project, not a solo project.

My main contribution focused on the later-stage analytics work:

- house-rules text processing
- sentiment analysis
- LDA topic modeling
- random forest modeling
- model interpretation

I also did some cleaning and clustering in my own R workflow. The broader team project included earlier-stage data preparation, descriptive analysis, the original report, slides, dashboard-style outputs, and recommendations.

For a clearer ownership note, see [contribution-note.md](contribution-note.md).

## Methodology

- Loaded the Airbnb Open Data CSV in R.
- Cleaned price and service-fee fields by removing currency symbols and converting them to numeric values.
- Checked duplicates, missing values, category inconsistencies, date fields, and the mostly empty `license` field.
- Created simple derived fields such as `price_per_night` and `reviews_per_year`.
- Reviewed listing patterns by room type, neighborhood, price, review fields, and geography.
- Used k-means clustering and map-based visual review for exploratory segmentation.
- Tokenized `house_rules`, removed stop words, and created sentiment scores using the Bing lexicon.
- Used LDA topic modeling to summarize common themes in house rules.
- Combined structured listing variables with text-derived features.
- Trained a random forest regression model to predict `number of reviews`.
- Interpreted the model using variable importance and partial dependence.

The repository includes dashboard-style screenshots, but the live dashboard source file is not included.

## Key Findings

- Entire home/apartment and private room listings made up most of the dataset.
- Brooklyn and Manhattan had strong listing concentration in the project visuals.
- The random forest model suggested that availability, minimum nights, and price were important predictors of review volume.
- House-rules text features added some context, but they appeared less important than the main operational variables.
- The model showed moderate predictive signal, with reported MAE 19.18, RMSE 35.36, and R-squared 0.349.

These findings should be interpreted as patterns in an observational dataset, not as causal conclusions.

## Visual Highlights

### Room Type Distribution

![Room Type Distribution](outputs/figures/room-type-distribution.png)

Room type patterns help describe the listing market, but they do not directly measure bookings or revenue.

### Top Neighborhoods by Listing Count

![Top Neighborhoods](outputs/figures/top-neighborhoods-listing-count.png)

This chart summarizes listing concentration by neighborhood.

### Dashboard-Style Screenshot

![Dashboard View](outputs/figures/dashboard-map-and-top-reviews.png)

This is a static screenshot from the original project materials. The live dashboard source is not included in this repository.

### Model Interpretation

![Model Interpretation](outputs/figures/model-interpretation-panels.png)

Availability, minimum nights, and price were important predictors in the random forest model. This does not establish causal effects.

## Model Evaluation Note

The random forest model used review count as the target variable and combined structured listing fields with sentiment and topic features from `house_rules`.

Reported model metrics:

- MAE: 19.18
- RMSE: 35.36
- R-squared: 0.349

These results are useful for interpretation, but they should not be treated as production-level performance. The repository includes optional cross-validation code in the modeling script, but confirmed cross-validation results are not included in the project documentation.

## Repository Structure

```text
airbnb-listing-engagement-analysis-r/
|-- README.md
|-- contribution-note.md
|-- data/
|   `-- README.md
|-- portfolio/
|   |-- README.md
|   `-- ALY6110_Module6_Airbnb_Portfolio.pdf
|-- scripts/
|   |-- 01_airbnb_data_cleaning_eda_wenzhuo.R
|   |-- 02_airbnb_text_modeling_random_forest_cheng.R
|   |-- README.md
|   `-- packages-used.md
|-- walkthrough/
|   `-- project-walkthrough.md
|-- outputs/
|   |-- README.md
|   `-- figures/
|-- reports/
|   `-- ALY6110_Module6_Final_Report.pdf
`-- slides/
    `-- ALY6110_Module6_Final_Presentation.pdf
```

## How to Reproduce

1. Download the Airbnb Open Data CSV from Kaggle.
2. Place the file at `data/Airbnb_Open_Data.csv`.
3. Install the R packages listed in [scripts/packages-used.md](scripts/packages-used.md).
4. Run the scripts from the repository root:
   - `scripts/01_airbnb_data_cleaning_eda_wenzhuo.R`
   - `scripts/02_airbnb_text_modeling_random_forest_cheng.R`

Notes:

- Script 1 writes a cleaned file named `Airbnb.csv` at the repository root if it is run from the root folder.
- Script 2 includes optional cross-validation code that is marked as time-consuming in the project materials.
- The dashboard source file is not included, so dashboard screenshots cannot be regenerated from this repository alone.

## Limitations

- This was a two-person course project, not a solo professional engagement.
- `number of reviews` is only a proxy for listing engagement and does not directly measure bookings, revenue, occupancy, or guest satisfaction.
- The dataset is observational, so the findings should not be interpreted as causal effects.
- The random forest model showed moderate predictive signal, not high-accuracy or production-ready performance.
- A confirmed baseline model and confirmed completed cross-validation results are not included in the documentation.
- Many `house_rules` values are missing or may contain data artifacts, so text findings should be interpreted carefully.
- The repository includes static dashboard screenshots, but not the live dashboard source file.
- No SQL, Streamlit, GenAI/LLM, MLOps, cloud deployment, or production system component is confirmed from the project files.

## Future Improvements

- Add a short data dictionary for the main columns used in the analysis.
- Add clearer data-quality checks for duplicate listings, missing `house_rules`, invalid availability values, and unusual date values.
- Add a simple baseline model before the random forest model.
- Keep all text feature engineering inside the training workflow to reduce possible leakage in future modeling work.
- Rebuild or include a reproducible dashboard source if dashboard work is part of a future version.
- Rewrite the model interpretation visuals with more cautious wording around association rather than causation.

## Related Files

- [Contribution note](contribution-note.md)
- [Project walkthrough](walkthrough/project-walkthrough.md)
- [Data note](data/README.md)
- [Scripts guide](scripts/README.md)
- [Package list](scripts/packages-used.md)
- [Cleaning and EDA script](scripts/01_airbnb_data_cleaning_eda_wenzhuo.R)
- [Text modeling and random forest script](scripts/02_airbnb_text_modeling_random_forest_cheng.R)
- [Outputs guide](outputs/README.md)
- [Selected figures folder](outputs/figures/)
- [Final report PDF](reports/ALY6110_Module6_Final_Report.pdf)
- [Final presentation PDF](slides/ALY6110_Module6_Final_Presentation.pdf)
- [Portfolio PDF](portfolio/ALY6110_Module6_Airbnb_Portfolio.pdf)
