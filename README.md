# Airbnb Listing Engagement Analysis in R

This repository is a public portfolio version of my ALY6110 final project at Northeastern University.

My teammate and I analyzed 100K+ NYC Airbnb listings to study what may affect listing engagement. In this project, I mainly worked on the later-stage analytics part, especially the house rules text analysis, topic modeling, and random forest modeling. I also did some data cleaning and clustering in my own R script.

This repo also includes a polished portfolio version of the project in PDF format for easier review.

## Project Overview

This was a 2-person team project for **ALY6110: Big Data and Data Management (Fall 2024)**.

We used the **Airbnb Open Data** dataset from Kaggle and treated **number of reviews** as a simple proxy for listing success. The main goal was to understand which structured and text-based factors may be related to guest engagement.

## Business Problem

Airbnb hosts and investors want to know what makes some listings perform better than others.

In this project, we looked at listing features such as price, availability, minimum nights, room type, location, and house rules. We wanted to see which factors were most related to review volume and whether text from house rules could add useful signal.

## My Role

This was a team project, not a solo project.

My main work was:
- house rules text processing
- sentiment analysis
- LDA topic modeling
- random forest modeling
- model interpretation

I also did some cleaning and clustering in my own R workflow.

For a more honest breakdown, see [contribution-note.md](contribution-note.md).

## Main Methods

- Data cleaning in R
- Feature engineering
- Descriptive analysis and charts
- K-means clustering
- Geographic/dashboard-style visual analysis
- Sentiment analysis on `house_rules`
- LDA topic modeling
- Random forest modeling
- Variable importance and partial dependence review

## Key Results

- Entire home/apt and private room made up most listings.
- Brooklyn and Manhattan had strong listing concentration.
- Availability, minimum nights, and price were the strongest predictors in the model.
- House rules text features added some signal, but less than the main operational variables.
- The random forest model reached about **R² = 0.349**, with **MAE = 19.18** and **RMSE = 35.36**.

## Selected Visuals

### Room Type Distribution
![Room Type Distribution](outputs/figures/room-type-distribution.png)

### Top Neighborhoods by Listing Count
![Top Neighborhoods](outputs/figures/top-neighborhoods-listing-count.png)

### Dashboard View
![Dashboard View](outputs/figures/dashboard-map-and-top-reviews.png)

### Model Interpretation
![Model Interpretation](outputs/figures/model-interpretation-panels.png)

## Portfolio Version

This repo also includes a cleaner portfolio-style version of the project:

- [Portfolio folder note](portfolio/README.md)
- [Portfolio PDF](portfolio/ALY6110_Module6_Airbnb_Portfolio.pdf)

## Repository Guide

- [Project walkthrough](walkthrough/project-walkthrough.md)
- [Final report](reports/ALY6110_Module6_Final_Report.pdf)
- [Final slides](slides/ALY6110_Module6_Final_Presentation.pdf)
- [Scripts](scripts/README.md)
- [Outputs and figures](outputs/README.md)
- [Data note](data/README.md)
- [Contribution note](contribution-note.md)

## Project Structure

```text
airbnb-listing-engagement-analysis-r/
├─ README.md
├─ .gitignore
├─ contribution-note.md
├─ data/
│  └─ README.md
├─ portfolio/
│  ├─ README.md
│  ├─ ALY6110_Module6_Airbnb_Portfolio.pdf
├─ scripts/
│  ├─ 01_airbnb_data_cleaning_eda_wenzhuo.R
│  ├─ 02_airbnb_text_modeling_random_forest_cheng.R
│  ├─ README.md
│  └─ packages-used.md
├─ walkthrough/
│  └─ project-walkthrough.md
├─ outputs/
│  ├─ README.md
│  └─ figures/
├─ reports/
│  └─ ALY6110_Module6_Final_Report.pdf
└─ slides/
   └─ ALY6110_Module6_Final_Presentation.pdf
```

## Dataset Note

The full raw dataset is **not tracked** in the public GitHub version of this repository.

Please see [data/README.md](data/README.md) for the dataset source, expected filename, and reproduction note.

## Notes

- This repo is a cleaned public version for portfolio use.
- I kept the final report, final slides, original script structure, and selected outputs so the project still feels real and traceable.
- I also added a polished portfolio PDF version for faster review.
- Some wording in the original course materials was cleaned for consistency in this GitHub version.
