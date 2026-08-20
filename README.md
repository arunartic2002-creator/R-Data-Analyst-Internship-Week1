# Virtual R Data Analyst Internship - Week 1

## Task
**Data Cleaning and Preliminary Analysis with R**

## Dataset
Titanic passenger training dataset containing **891 observations and 12 variables**.

Source: Kaggle, *Titanic - Machine Learning from Disaster*  
https://www.kaggle.com/competitions/titanic

The Kaggle competition describes `train.csv` as a dataset of 891 passengers with survival outcomes. The dataset contains numerical and categorical variables and missing values, making it suitable for this internship task.

## Project Structure

```text
R_Data_Analyst_Internship_Week1/
├── data/
│   └── titanic_train.csv
├── R/
│   └── week1_titanic_analysis.R
├── outputs/
│   ├── titanic_cleaned.csv
│   ├── titanic_cleaned_encoded.csv
│   ├── missing_values_before.csv
│   ├── summary_before.csv
│   ├── summary_after.csv
│   ├── outlier_detection.csv
│   ├── survival_by_sex.csv
│   ├── survival_by_class.csv
│   └── correlation_matrix.csv
├── visualizations/
│   ├── 01_missing_values.png
│   ├── 02_age_distribution.png
│   ├── 03_fare_boxplot.png
│   ├── 04_survival_by_sex.png
│   ├── 05_survival_by_class.png
│   └── 06_correlation_matrix.png
├── report/
│   └── Week1_R_Data_Analyst_Report.docx
└── README.md
```

## Cleaning Methods

1. Standardized selected text fields.
2. Imputed missing `Age` values with the median.
3. Imputed missing `Embarked` values with the mode.
4. Removed `Cabin` because of very high missingness.
5. Removed exact duplicate rows.
6. Detected numerical outliers using the IQR rule.
7. Capped numerical outliers to IQR boundaries instead of deleting observations.
8. Applied Min-Max normalization to selected numerical variables.
9. Encoded `Sex` as binary and `Embarked` using one-hot encoding.

## Preliminary Findings

- Female passengers had a substantially higher survival rate than male passengers.
- First-class passengers had a higher survival rate than second- and third-class passengers.
- Fare and passenger class show a meaningful relationship with survival.
- Age has a weaker linear relationship with survival than sex and passenger class.
- Missing values were concentrated mainly in `Cabin` and `Age`.

## How to Run in RStudio

1. Open the project folder in RStudio.
2. Open `R/week1_titanic_analysis.R`.
3. Install the required packages if prompted.
4. Run the script from top to bottom.
5. Review the console outputs and plots.
6. The cleaned dataset will be saved under `outputs/`.

## Important
The report includes reproducible R code. The visual outputs included in the submission package were generated from the same documented cleaning and analysis logic so the project can be reviewed immediately; rerunning the R script in RStudio reproduces the analysis.
