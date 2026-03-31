# Load necessary libraries
library(dplyr)
library(ggplot2)
library(corrplot)
library(tidyr)
library(cluster)
library(sf)
library(leaflet)
library(leaflet.extras)
library(reshape2)
library(tidytext)
library(textdata)
library(topicmodels)
library(caret)
library(randomForest)
library(pdp)

# Load Data
file_path <- "data/Airbnb_Open_Data.csv"
airbnb_data <- read.csv(file_path, stringsAsFactors = FALSE)
print(head(airbnb_data))
print(str(airbnb_data))
print(colnames(airbnb_data))

# =========================
# Data Cleaning
# =========================
# Remove $ and commas from price and convert to numeric
airbnb_data$price <- as.numeric(gsub("[$,]", "", airbnb_data$price))

# Replace empty strings with NA in last.review
airbnb_data$last.review[airbnb_data$last.review == ""] <- NA

# Convert last.review to Date
airbnb_data$last.review <- as.Date(airbnb_data$last.review, format = "%m/%d/%Y")
print(str(airbnb_data))

# Keep a copy for later modeling before exploratory imputation
airbnb_data_raw <- airbnb_data

# Fill missing numerical values with column mean for exploratory analysis
numerical_cols <- sapply(airbnb_data, is.numeric)
airbnb_data[numerical_cols] <- lapply(airbnb_data[numerical_cols], function(x) {
  ifelse(is.na(x), mean(x, na.rm = TRUE), x)
})

# Fill missing categorical values with mode
fill_mode <- function(x) {
  x[is.na(x)] <- names(sort(table(x), decreasing = TRUE))[1]
  x
}
categorical_cols <- sapply(airbnb_data, is.character)
airbnb_data[categorical_cols] <- lapply(airbnb_data[categorical_cols], fill_mode)

# Add new features: price_per_night and reviews_per_year
airbnb_data <- airbnb_data %>%
  mutate(price_per_night = price / minimum.nights,
         reviews_per_year = reviews.per.month * 12)
print(str(airbnb_data))

# =========================
# Correlation Analysis
# =========================
# Select features for correlation
correlation_features <- c("price", "minimum.nights", "reviews.per.month", 
                          "availability.365", "calculated.host.listings.count")
correlation_matrix <- cor(airbnb_data[, correlation_features], use = "complete.obs")
print(correlation_matrix)

# Correlation heatmap for quick visualization
corrplot(correlation_matrix, method = "color", 
         col = colorRampPalette(c("red", "white", "blue"))(200),
         tl.col = "black", tl.cex = 0.8, title = "Correlation Heatmap", mar = c(0, 0, 1, 0))

# =========================
# Clustering Analysis
# =========================
# Scale selected features
selected_features <- airbnb_data[, correlation_features]
scaled_features <- scale(selected_features)

# K-Means Clustering (k=4)
set.seed(42)
kmeans_result <- kmeans(scaled_features, centers = 4, nstart = 25)
airbnb_data$Cluster <- as.factor(kmeans_result$cluster)
print(kmeans_result)

# =========================
# Room Type Distribution Across Clusters
# =========================
# Calculate distribution of room types within each cluster
room_type_distribution <- airbnb_data %>%
  group_by(Cluster, room.type) %>%
  summarize(Count = n(), .groups = "drop") %>%
  mutate(Percentage = Count / sum(Count))
print(room_type_distribution)

# Visualize room type distribution
ggplot(room_type_distribution, aes(x = Cluster, y = Percentage, fill = room.type)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Room Type Distribution Across Clusters", x = "Cluster", y = "Percentage") +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent)

# =========================
# Top Neighborhoods by Listings
# =========================
# Identify neighborhoods with the most listings
top_neighborhoods <- airbnb_data %>%
  count(neighbourhood) %>%
  arrange(desc(n)) %>%
  slice_head(n = 10)
print(top_neighborhoods)

# Visualize top neighborhoods by count
ggplot(top_neighborhoods, aes(x = reorder(neighbourhood, n), y = n)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  coord_flip() +
  labs(title = "Top 10 Neighborhoods by Number of Listings", x = "Neighborhood", y = "Number of Listings") +
  theme_minimal()

# =========================
# Boxplot for Price
# =========================
# Check price distribution and identify outliers
ggplot(airbnb_data, aes(y = price)) +
  geom_boxplot(fill = "lightblue", outlier.color = "red") +
  labs(title = "Boxplot of Airbnb Prices", y = "Price") +
  theme_minimal()
print(summary(airbnb_data$price))

# Top 10 neighborhoods by average price
neighborhood_price <- airbnb_data %>%
  filter(!is.na(price)) %>%
  group_by(neighbourhood) %>%
  summarize(avg_price = mean(price, na.rm = TRUE)) %>%
  arrange(desc(avg_price)) %>%
  slice_head(n = 10)
print(neighborhood_price)

ggplot(neighborhood_price, aes(x = reorder(neighbourhood, avg_price), y = avg_price)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  coord_flip() +
  labs(title = "Average Price by Top 10 Neighborhoods",
       x = "Neighborhood",
       y = "Average Price ($)") +
  theme_minimal()

# =========================
# Neighborhood Clusters
# =========================
# Prepare data for mapping clusters
map_data <- airbnb_data %>%
  filter(!is.na(lat) & !is.na(long)) %>%
  mutate(Cluster = as.factor(Cluster))
print(head(map_data))

# Plot clusters on a map (static)
ggplot() +
  geom_point(data = map_data, aes(x = long, y = lat, color = Cluster), alpha = 0.6, size = 1.2) +
  scale_color_manual(values = c("red", "green", "blue", "purple")) +
  labs(title = "Airbnb Neighborhood Clusters",
       subtitle = "Mapped by Latitude and Longitude",
       x = "Longitude",
       y = "Latitude",
       color = "Cluster") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "right")

# Interactive map with leaflet
leaflet(data = map_data) %>%
  addTiles() %>%
  addMarkers(~long, ~lat, clusterOptions = markerClusterOptions())

# Heatmap of listing locations
leaflet(data = map_data) %>%
  addTiles() %>%
  addHeatmap(~long, ~lat, blur = 20, max = 0.5, radius = 15)

# Summarize cluster averages
cluster_summary <- map_data %>%
  group_by(Cluster) %>%
  summarize(
    AvgPrice = mean(price, na.rm = TRUE),
    AvgReviews = mean(reviews_per_year, na.rm = TRUE),
    AvgAvailability = mean(availability.365, na.rm = TRUE)
  )
print(cluster_summary)

cluster_melt <- melt(cluster_summary, id.vars = "Cluster")
print(cluster_melt)

ggplot(cluster_melt, aes(x = Cluster, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Cluster Averages by Feature",
       x = "Cluster",
       y = "Value",
       fill = "Feature") +
  theme_minimal()

# =============================================
# Advanced Analysis & NLP
# =============================================

# STEP 1: SENTIMENT ANALYSIS - Tokenize and assess sentiment of house rules
tidy_rules <- airbnb_data %>%
  select(id, house_rules) %>%
  unnest_tokens(word, house_rules) %>%
  anti_join(stop_words, by = "word")

print(head(tidy_rules))

bing <- get_sentiments("bing")

rules_sentiment <- tidy_rules %>%
  inner_join(bing, by = "word") %>%
  group_by(id) %>%
  summarize(sentiment_score = sum(ifelse(sentiment == "positive", 1, -1)), .groups = "drop")

print(head(rules_sentiment))

# Merge sentiment scores with main data
airbnb_data <- airbnb_data %>%
  left_join(rules_sentiment, by = "id") %>%
  mutate(sentiment_score = replace_na(sentiment_score, 0))

# Distribution of sentiment scores
ggplot(airbnb_data, aes(x = sentiment_score)) +
  geom_histogram(bins = 30, fill = "blue", color = "white") +
  theme_minimal() +
  labs(title = "Distribution of Sentiment Scores in House Rules")

# STEP 2: TOPIC MODELING - Identify main themes in house rules
rules_dtm <- tidy_rules %>%
  count(id, word) %>%
  cast_dtm(document = id, term = word, value = n)
print(rules_dtm)

set.seed(123)
lda_model <- LDA(rules_dtm, k = 3, control = list(seed = 123))
topics <- tidy(lda_model, matrix = "beta")
print(head(topics))

top_terms <- topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup() %>%
  arrange(topic, -beta)
print(top_terms)

# Get document-topic distributions (gamma)
topic_gamma <- tidy(lda_model, matrix = "gamma")

# Convert topic_gamma to wide format
topic_wide <- topic_gamma %>%
  pivot_wider(names_from = topic, values_from = gamma, values_fill = 0) %>%
  rename(Topic1 = `1`, Topic2 = `2`, Topic3 = `3`)

# `document` in topic_gamma corresponds to `id` in airbnb_data
# Make sure `document` is a character and matches `id` in airbnb_data if needed
topic_wide <- topic_wide %>%
  mutate(id = as.integer(document))  # convert document back to integer if 'id' was int

# Merge topic_wide into the main dataset
airbnb_data <- airbnb_data %>%
  left_join(topic_wide, by = "id")
print(str(airbnb_data))

# STEP 3: MODELING listing engagement
# Here we use the derived features (sentiment and topics) along with existing numeric features to predict engagement
# Engagement metric: number.of.reviews
model_features <- airbnb_data %>%
  select(id, sentiment_score, Topic1, Topic2, Topic3)

model_data <- airbnb_data_raw %>%
  select(id, number.of.reviews, price, availability.365, minimum.nights, room.type) %>%
  left_join(model_features, by = "id") %>%
  select(-id) %>%
  filter(!is.na(number.of.reviews))

model_data$room.type <- as.factor(model_data$room.type)
set.seed(123)
train_index <- createDataPartition(model_data$number.of.reviews, p = 0.7, list = FALSE)
train_data <- model_data[train_index,]
test_data <- model_data[-train_index,]

# Fill missing numerical values with training-set mean
model_numeric_cols <- sapply(train_data, is.numeric)
model_numeric_cols["number.of.reviews"] <- FALSE
train_means <- sapply(train_data[, model_numeric_cols, drop = FALSE], function(x) {
  if (all(is.na(x))) {
    NA_real_
  } else {
    mean(x, na.rm = TRUE)
  }
})

for (col_name in names(train_means)) {
  train_data[[col_name]][is.na(train_data[[col_name]])] <- train_means[[col_name]]
  test_data[[col_name]][is.na(test_data[[col_name]])] <- train_means[[col_name]]
}

train_data <- na.omit(train_data)
test_data <- na.omit(test_data)

# Fit a Random Forest model to predict number.of.reviews
rf_model <- randomForest(number.of.reviews ~ ., data = train_data, ntree = 100, mtry = 3, importance = TRUE)
rf_preds <- predict(rf_model, newdata = test_data)

# Evaluate model performance
MAE <- mean(abs(rf_preds - test_data$number.of.reviews))
RMSE <- sqrt(mean((rf_preds - test_data$number.of.reviews)^2))
R2 <- 1 - (sum((rf_preds - test_data$number.of.reviews)^2) / sum((test_data$number.of.reviews - mean(test_data$number.of.reviews))^2))

cat("MAE:", MAE, "\n")
cat("RMSE:", RMSE, "\n")
cat("R-squared:", R2, "\n")

# STEP 4: INTERPRET RESULTS
# Check variable importance to see which features contribute most to predicting reviews
importance_rf <- importance(rf_model)
print(importance_rf)
varImpPlot(rf_model, main = "Variable Importance for Predicting Number of Reviews")

# The partial dependence plot shows how predictions change as we vary one predictor 
if(requireNamespace("pdp", quietly = TRUE)){
  partial_plot <- partial(rf_model, pred.var = "sentiment_score", train = train_data)
  autoplot(partial_plot) + theme_minimal() + 
    labs(title = "Partial Dependence of Sentiment Score on Number of Reviews")
}

# =============================================
# Cross-Validation (Warning: This will take more than 3 hours to complete)
# =============================================
set.seed(123)  # Ensure reproducibility
control <- trainControl(method = "cv", number = 5)

# Train the Random Forest model with cross-validation on training data
rf_cv_model <- train(
  number.of.reviews ~ sentiment_score + Topic1 + Topic2 + Topic3 + 
    price + availability.365 + minimum.nights + room.type,
  data = train_data,
  method = "rf",
  trControl = control,
  tuneLength = 3
)

# Print cross-validation results
print(rf_cv_model)

# Extract and summarize model performance
cv_results <- rf_cv_model$results
print(cv_results)

# Best model performance
best_model <- rf_cv_model$finalModel
print(best_model)

# Predictions on test data
cv_preds <- predict(rf_cv_model, newdata = test_data)

# Evaluate tuned model performance on held-out test data
cv_MAE <- mean(abs(cv_preds - test_data$number.of.reviews))
cv_RMSE <- sqrt(mean((cv_preds - test_data$number.of.reviews)^2))
cv_R2 <- 1 - (sum((cv_preds - test_data$number.of.reviews)^2) / 
                sum((test_data$number.of.reviews - mean(test_data$number.of.reviews))^2))

cat("Held-out Test MAE after CV tuning:", cv_MAE, "\n")
cat("Held-out Test RMSE after CV tuning:", cv_RMSE, "\n")
cat("Held-out Test R-squared after CV tuning:", cv_R2, "\n")
