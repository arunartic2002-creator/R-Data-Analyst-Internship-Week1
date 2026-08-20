# Week 1 - Data Cleaning and Preliminary Analysis with R
# Virtual R Data Analyst Internship
# Dataset: Titanic train.csv (891 observations, 12 variables)
# Source: Kaggle Titanic - Machine Learning from Disaster
# https://www.kaggle.com/competitions/titanic

# 1. Load packages
required_packages <- c("dplyr", "ggplot2", "readr", "tidyr")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)
lapply(required_packages, library, character.only = TRUE)

# 2. Load data
data <- read_csv("data/titanic_train.csv", show_col_types = FALSE)

# 3. Initial inspection
dim(data)
str(data)
summary(data)

# Missing-value count
missing_summary <- data %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Missing_Count") %>%
  mutate(Missing_Percent = round(Missing_Count / nrow(data) * 100, 2))

print(missing_summary)

# 4. Remove exact duplicate rows
data <- data %>% distinct()

# 5. Handle missing values
# Age: median imputation because it is numerical and moderately skewed.
age_median <- median(data$Age, na.rm = TRUE)
data$Age[is.na(data$Age)] <- age_median

# Embarked: mode imputation for the two missing categorical records.
mode_embarked <- names(sort(table(data$Embarked), decreasing = TRUE))[1]
data$Embarked[is.na(data$Embarked)] <- mode_embarked

# Cabin: approximately 77% missing in the original dataset, so it is
# removed from this preliminary analysis instead of applying heavy imputation.
data <- data %>% select(-Cabin)

# 6. Outlier detection using the IQR method
detect_outliers <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - 1.5 * iqr
  upper <- q3 + 1.5 * iqr
  sum(x < lower | x > upper, na.rm = TRUE)
}

sapply(data[c("Age", "Fare", "SibSp", "Parch")], detect_outliers)

# Cap numerical outliers using IQR boundaries while retaining observations.
cap_iqr <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - 1.5 * iqr
  upper <- q3 + 1.5 * iqr
  pmin(pmax(x, lower), upper)
}

data$Age <- cap_iqr(data$Age)
data$Fare <- cap_iqr(data$Fare)
data$SibSp <- cap_iqr(data$SibSp)
data$Parch <- cap_iqr(data$Parch)

# 7. Min-Max normalization
min_max <- function(x) {
  (x - min(x, na.rm = TRUE)) /
    (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

data$Age_Normalized <- min_max(data$Age)
data$Fare_Normalized <- min_max(data$Fare)
data$SibSp_Normalized <- min_max(data$SibSp)
data$Parch_Normalized <- min_max(data$Parch)

# 8. Categorical encoding
data$Sex_Encoded <- ifelse(data$Sex == "male", 1, 0)

data <- data %>%
  mutate(
    Embarked = factor(Embarked),
    Embarked_C = ifelse(Embarked == "C", 1, 0),
    Embarked_Q = ifelse(Embarked == "Q", 1, 0),
    Embarked_S = ifelse(Embarked == "S", 1, 0)
  )

# 9. Summary statistics
summary(data[c("Age", "SibSp", "Parch", "Fare")])

# 10. Correlation analysis
cor(data[c("Survived", "Pclass", "Age", "SibSp", "Parch", "Fare")])

# 11. Preliminary insights
data %>%
  group_by(Sex) %>%
  summarise(
    Passengers = n(),
    Survivors = sum(Survived),
    Survival_Rate = round(mean(Survived) * 100, 2)
  )

data %>%
  group_by(Pclass) %>%
  summarise(
    Passengers = n(),
    Survivors = sum(Survived),
    Survival_Rate = round(mean(Survived) * 100, 2)
  )

# 12. Visualizations
ggplot(data, aes(x = Age)) +
  geom_histogram(bins = 25) +
  labs(title = "Age Distribution After Cleaning",
       x = "Age", y = "Frequency") +
  theme_minimal()

ggplot(data, aes(x = Sex, y = Survived)) +
  stat_summary(fun = mean, geom = "bar") +
  labs(title = "Survival Rate by Sex",
       y = "Survival Rate", x = "Sex") +
  theme_minimal()

ggplot(data, aes(x = factor(Pclass), y = Survived)) +
  stat_summary(fun = mean, geom = "bar") +
  labs(title = "Survival Rate by Passenger Class",
       x = "Passenger Class", y = "Survival Rate") +
  theme_minimal()

# 13. Save cleaned data
write_csv(data, "outputs/titanic_cleaned_encoded_from_R.csv")
