# Hospital Length of Stay Prediction Project

## Project Overview
This project aims to develop machine learning models to predict hospital length of stay (LOS) at the time of patient admission. The goal is to support hospital resource planning and improve patient care by estimating LOS using only admission-time features.

## Dataset Source
The dataset was extracted from the **NHS Data Warehouse** under the governance of **Somerset NHS Foundation Trust**, specifically from **Musgrove Park Hospital**. Data was retrieved using SQL queries and includes both **emergency** and **elective** cardiology admissions.  
- **Emergency dataset:** 2020–2024  
- **Elective dataset:** 2015–2024  

Due to data confidentiality, the repository includes a **dummy dataset** (`Dummy_dataset/`) to help users understand the data structure.

## Methodology Summary
- Data extraction via SQL  
- Preprocessing: handling missing values, encoding categorical features  
- Feature selection: admission-time variables only  
- Model training: Linear Regression, Random Forest, and XGBoost  
- Hyperparameter tuning: Optuna (XGBoost, Random Forest)  
- Evaluation metrics: MAE, RMSE, R² Score  

## Folder Structure
- `graphs/`
  - `emergency/`: Visualizations specific to emergency admissions  
  - `elective/`: Visualizations specific to elective admissions  
  - Graphs outside these folders apply to both types  

- `notebooks/`
  - `Los_analysis_emerg_elect_2020_to_24/`: Contains initial analysis; a good starting point  
  - `LOS_EMERG/`: Main notebook focused on emergency patients  
  - `Los_ELECT/`: Contains a brief analysis of elective patients  

- `Dummy_dataset/`
  - Includes a dummy dataset (Excel) to understand the data structure without exposing confidential information.

## Navigation Instructions
- Start by reviewing the **dummy dataset** in to understand the data format.  
- Open the `notebooks/Los_analysis_emerg_elect_2020_to_24/` notebook for initial analysis.  
- Continue with the `notebooks/LOS_EMERG/` notebook, which contains the main modeling workflow.  
- Explore the `graphs/` folder for visualizations from exploratory data analysis and model evaluation.  
