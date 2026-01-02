# Temperature Analysis using Exponential Smoothing

## Overview
This project analyzes 20 years of daily high temperature data for Atlanta (July through October) to determine whether the unofficial end of summer has shifted later over time. The analysis employs exponential smoothing models, specifically Holt-Winters methods, to extract and analyze temperature trends.

## Research Question
Has the unofficial end of summer in Atlanta gotten later over the past 20 years?

## Dataset
- **Source**: `temps.txt`
- **Time Period**: 20 years of historical data
- **Months Covered**: July through October
- **Data Type**: Daily high temperatures

## Methodology

### Analysis Pipeline
1. **Data Loading and Preparation**
   - Load temperature data from file
   - Identify year columns using pattern matching
   - Convert data into long format with separate year column
   - Remove missing values and validate data integrity

2. **Time Series Conversion**
   - Transform data frame into time series object for analysis

3. **Exponential Smoothing Models**
   - **Holt-Winters Additive Model**: Assumes seasonal variations are constant over time
   - **Holt-Winters Multiplicative Model**: Assumes seasonal variations change proportionally with the level

4. **Model Selection**
   - Compare models using Sum of Squared Errors (SSE)
   - Select the model with lower SSE for final analysis

5. **Trend Analysis**
   - Extract trend component from the selected model
   - Focus on the last 50% of data to identify recent patterns
   - Determine when summer effectively ends each year

6. **Statistical Testing**
   - Calculate trend coefficients
   - Compute p-values to assess statistical significance
   - Draw conclusions based on statistical evidence

## Tools & Technologies
- **Language**: R
- **Key Packages**:
  - `HoltWinters()` - For simpler exponential smoothing
  - `smooth` package with `es()` function - For more general modeling (model="AAM")
  - Standard R time series functions

## Key Outputs
- Visual comparison of additive vs. multiplicative models
- SSE comparison for model selection
- Trend plots showing temperature patterns over years
- Statistical coefficients and p-values for trend significance

## Results
The analysis provides evidence-based insights into whether Atlanta's summer season has extended later into the fall over the 20-year observation period.

## Files
- `temps.txt` - Raw temperature data
- - `Solution.R` - Solution (R code) 
- `Analysis.pdf` - Detailed solution methodology
- Analysis scripts (R code)

## Learning Outcomes
This project demonstrates:
- Time series data manipulation and cleaning
- Application of exponential smoothing techniques
- Model comparison and selection
- Trend analysis and statistical hypothesis testing
- Data visualization for temporal patterns
