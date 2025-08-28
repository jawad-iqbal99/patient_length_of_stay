# Hospital Length of Stay Prediction Project

## Author
**Jawad Iqbal**

## Project Overview
This project aims to develop machine learning models to predict hospital length of stay (LOS) at the time of patient admission. The goal is to support hospital resource planning and improve patient care by estimating LOS using only admission-time features.

## Dataset Source
The dataset was extracted from the **NHS Data Warehouse** under the governance of **Somerset NHS Foundation Trust**, specifically from **Musgrove Park Hospital**. Data was retrieved using SQL queries and includes both **emergency** and **elective** cardiology admissions. The emergency dataset spans from 2020 to 2024, while the elective dataset covers 2018 to 2024.

## Methodology Summary
- Data extraction via SQL
- Preprocessing: handling missing values, encoding categorical features
- Feature selection: admission-time variables only
- Model training: Linear Regression, Random Forest, and XGBoost
- Hyperparameter tuning: Optuna (XGBoost), RandomizedSearchCV (Random Forest)
- Evaluation metrics: MAE, RMSE, R² Score

## Folder Structure
- `graphs/`
  - `emergency/`: Visualizations specific to emergency admissions
  - `elective/`: Visualizations specific to elective admissions
  - Graphs outside these folders apply to both types

- `notebooks/`
  - `Los_analysis_emerg_elect_2020_to_24/` : Contain initial analysis, This is good point to start
  - `LOS_EMERG/` : This is the main notebook of my work (this is for emergency patients)
  - `Los_ELECT/` : This contain just some breif analysis about elective patients
- `Dummay_dateset/`
- Becaues I am working with confidential data and can't share it, this excel file contain a dummay dataset just to understand the data.

## Navigation Instructions
- Start by reviewing the notebooks in the `notebooks/` folder to understand the modeling workflow.
- Use the `graphs/` folder to explore visualizations from exploratory data analysis and model evaluation.
