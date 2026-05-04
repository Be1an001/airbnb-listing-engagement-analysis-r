# Project Walkthrough

This walkthrough explains the main project flow for the Airbnb Listing Engagement Analysis in R. It is a public portfolio version of a two-person ALY6110 course project at Northeastern University.

The project studies NYC Airbnb listing data and uses `number of reviews` as a practical proxy for listing engagement. It does not directly measure bookings, revenue, occupancy, conversion, or guest satisfaction.

## Business Problem

Airbnb hosts and analysts may want to understand which listing features are associated with more guest attention. In this project, the main question was:

**Which listing factors seem related to higher review volume, and can house-rules text add useful information?**

The analysis looked at:

- room type
- price
- availability
- minimum nights
- neighborhood and location
- `house_rules` text

Because the dataset is observational, the findings should be interpreted as associations rather than causal effects.

## Project Objective

The goal was to build a practical R analytics workflow that connected basic market analysis with text mining and model interpretation.

The workflow included:

- loading and cleaning listing-level Airbnb data
- exploring room type, neighborhood, price, review, and availability patterns
- using dashboard-style screenshots to communicate visual patterns
- processing `house_rules` text into sentiment and topic features
- training a random forest regression model for review volume
- interpreting model results carefully

## Team and Contribution Note

This was a two-person course project, not a solo project.

My main contribution focused on the later-stage analytics work:

- house-rules text processing
- sentiment scoring
- LDA topic modeling
- random forest modeling
- model interpretation

I also did some cleaning and clustering in my own R script. My teammate handled much of the earlier-stage data preparation, descriptive analysis, and some original report and slide sections.

For the separate ownership note, see [../contribution-note.md](../contribution-note.md).

## Dataset

- Dataset: Airbnb Open Data
- Source: Kaggle
- Raw file used in the project: 102,599 rows and 26 columns
- Expected local path: `data/Airbnb_Open_Data.csv`
- Granularity: one row per Airbnb listing record
- Modeling target: `number of reviews`

Main field groups included listing identifiers, host information, neighborhood and geo fields, room type, price and service fee, minimum nights, review fields, availability fields, and `house_rules` text.

The public GitHub version is intended to keep the raw CSV out of version control. See [../data/README.md](../data/README.md) for the dataset source and reproduction note.

## Methodology

### 1. Data Cleaning

The project started with raw CSV cleaning work:

- checked duplicate rows
- cleaned `$` symbols and commas from price fields
- converted price and service-fee fields to numeric values
- handled missing values
- standardized selected neighborhood group values
- removed the mostly empty `license` field
- converted date fields

Related script:

- [../scripts/01_airbnb_data_cleaning_eda_wenzhuo.R](../scripts/01_airbnb_data_cleaning_eda_wenzhuo.R)

Selected code pattern:

```r
df <- read.csv("data/Airbnb_Open_Data.csv")

df$price <- gsub("[$,]", "", df$price)
df$price <- as.numeric(df$price)

df <- df[!duplicated(df), ]
df <- df[!is.na(df$price), ]
```

This step mattered because the raw file contained duplicate records, string-formatted prices, missing values, and fields that needed cleanup before analysis.

### 2. Exploratory Analysis

After cleaning, the project moved into descriptive analysis and visual review.

The analysis looked at:

- room type distribution
- top neighborhoods by listing count
- price patterns by room type and borough
- review-related patterns
- geographic concentration of listings
- exploratory clustering patterns

Selected figure:

![Room Type Distribution](../outputs/figures/room-type-distribution.png)

Selected figure:

![Top Neighborhoods](../outputs/figures/top-neighborhoods-listing-count.png)

Room type and neighborhood patterns help describe the listing market, but they do not directly measure bookings or revenue.

### 3. Dashboard-Style Visual Review

The original project materials included dashboard-style visuals to make the listing patterns easier to read.

The screenshot shows:

- map-based listing distribution
- price filter
- room type filter
- neighborhood group filter
- top reviewed listings

The live dashboard source file is not included in this repository, so the dashboard is represented as a static screenshot.

Selected figure:

![Dashboard](../outputs/figures/dashboard-map-and-top-reviews.png)

### 4. House-Rules Text Analysis

This was the part I mainly focused on. The goal was to see whether `house_rules` text could add context beyond the normal structured listing fields.

The text workflow included:

- tokenization
- stop-word removal
- Bing sentiment scoring
- LDA topic modeling
- merging text-derived features back into the listing data

Related script:

- [../scripts/02_airbnb_text_modeling_random_forest_cheng.R](../scripts/02_airbnb_text_modeling_random_forest_cheng.R)

Selected code pattern:

```r
tidy_rules <- airbnb_data %>%
  select(id, house_rules) %>%
  unnest_tokens(word, house_rules) %>%
  anti_join(stop_words, by = "word")

bing <- get_sentiments("bing")

rules_sentiment <- tidy_rules %>%
  inner_join(bing, by = "word") %>%
  group_by(id) %>%
  summarize(sentiment_score = sum(ifelse(sentiment == "positive", 1, -1)))
```

Selected figure:

![Sentiment Distribution](../outputs/figures/sentiment-score-distribution.png)

The sentiment findings should be interpreted carefully because many `house_rules` values are missing or may contain data artifacts.

The project slides summarized three broad LDA topic themes:

- cleanliness and house maintenance
- guest instructions and safety
- general stay-related rules

### 5. Random Forest Modeling

After creating text-based features, the project combined them with structured listing variables to model review volume.

The model used:

- sentiment score
- LDA topic probabilities
- price
- availability
- minimum nights
- room type

The main model was a random forest regression model.

Selected code pattern:

```r
rf_model <- randomForest(
  number.of.reviews ~ sentiment_score + Topic1 + Topic2 + Topic3 +
    price + availability.365 + minimum.nights + room.type,
  data = train_data,
  ntree = 100,
  mtry = 3,
  importance = TRUE
)
```

Selected figure:

![Model Interpretation](../outputs/figures/model-interpretation-panels.png)

Variable importance and partial dependence were used for interpretation. They should not be treated as causal evidence.

## Key Findings

- Entire home/apartment and private room listings made up most of the dataset.
- Brooklyn and Manhattan had strong listing concentration in the project visuals.
- The random forest model suggested that availability, minimum nights, and price were important predictors of review volume.
- House-rules text features added some context, but they appeared less important than the main operational variables.
- The model showed moderate predictive signal, with reported MAE 19.18, RMSE 35.36, and R-squared 0.349.

## Model Evaluation Note

The reported random forest metrics were:

- MAE: 19.18
- RMSE: 35.36
- R-squared: 0.349

These results suggest limited but useful modeling signal. They should not be described as high accuracy or production-ready performance.

The modeling script includes optional cross-validation code, but confirmed completed cross-validation results are not included in the project documentation.

## Limitations

- This was a two-person course project, so the full project should not be described as solo work.
- Review count is an imperfect proxy for listing engagement.
- The dataset does not directly measure bookings, revenue, occupancy, conversion, or guest satisfaction.
- The analysis is observational and does not support causal claims.
- Many `house_rules` values are missing or may contain artifacts, so text findings should be interpreted carefully.
- The dashboard is included only as static screenshots; the live dashboard source file is not included.
- No SQL, Streamlit, GenAI/LLM, MLOps, cloud deployment, or production system component is confirmed from the project files.
- The model documentation does not include a confirmed baseline model or confirmed completed cross-validation results.

## Future Improvements

- Add a short data dictionary for the main columns.
- Add clearer data validation for duplicates, missing text, invalid availability values, and unusual date values.
- Add a simple baseline model before the random forest model.
- Improve the text-modeling workflow so feature engineering is handled more carefully inside the modeling split.
- Recreate the dashboard from source if dashboard work becomes a main part of the portfolio version.
- Rewrite some slide captions with more cautious association-based wording.

## Related Files

- [Main README](../README.md)
- [Contribution note](../contribution-note.md)
- [Data note](../data/README.md)
- [Scripts guide](../scripts/README.md)
- [Package list](../scripts/packages-used.md)
- [Cleaning and EDA script](../scripts/01_airbnb_data_cleaning_eda_wenzhuo.R)
- [Text modeling and random forest script](../scripts/02_airbnb_text_modeling_random_forest_cheng.R)
- [Outputs guide](../outputs/README.md)
- [Final report PDF](../reports/ALY6110_Module6_Final_Report.pdf)
- [Final presentation PDF](../slides/ALY6110_Module6_Final_Presentation.pdf)
- [Portfolio PDF](../portfolio/ALY6110_Module6_Airbnb_Portfolio.pdf)
