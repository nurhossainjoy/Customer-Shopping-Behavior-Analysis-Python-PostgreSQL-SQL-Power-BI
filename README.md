# 🛍️ Customer Shopping Behavior Analysis

### Python | PostgreSQL | SQL | Power BI

An end-to-end data analytics project focused on customer purchasing behavior, revenue contribution, product performance, discount usage, customer segmentation, and subscription patterns. This project combines **Python-based data preparation, PostgreSQL business analysis, and Power BI dashboarding** to transform raw shopping data into meaningful business insights.

---

## 📌 Project Overview

Understanding customer behavior is essential for improving sales performance, customer retention, pricing strategies, and marketing effectiveness.

This project analyzes customer shopping data using Python, SQL, and Power BI. The workflow begins with data inspection and preprocessing in Pandas, continues with loading the cleaned dataset into PostgreSQL, and applies SQL queries to answer practical business questions. A Power BI report complements the analysis with interactive visualizations.

### Project Highlights

- Cleaned and transformed customer shopping data using Python and Pandas.
- Handled missing review ratings using category-level median imputation.
- Created customer age groups and purchase-frequency features.
- Loaded the transformed dataset into PostgreSQL using SQLAlchemy.
- Developed 10 SQL analyses to investigate business questions.
- Built a Power BI report featuring category-wise revenue, age-group analysis, and subscription-related visualizations.

---

## 🎯 Business Objectives

The main objectives of this project are to:

1. Compare revenue contributions from male and female customers.
2. Identify customers using discounts whose spending exceeds the overall average purchase amount.
3. Find products with the highest average customer review ratings.
4. Compare average purchase amounts between Standard and Express shipping.
5. Evaluate spending and revenue differences between subscribers and non-subscribers.
6. Analyze discount usage across purchased products.
7. Segment customers into New, Returning, and Loyal groups.
8. Identify the three most purchased products within each category.
9. Examine subscription status among customers with more than five previous purchases.
10. Compare revenue contributions across customer age groups.

---

## 🛠️ Tools & Technologies

| Technology | Purpose |
|---|---|
| Python | Data processing and transformation |
| Pandas | Data cleaning, manipulation, and feature engineering |
| NumPy | Numerical operations |
| Matplotlib | Visualization support |
| PostgreSQL | Relational database and SQL analysis |
| SQL | Business queries, aggregations, CTEs, and window functions |
| SQLAlchemy | Database connection and data loading |
| Psycopg2 | PostgreSQL connectivity |
| Power BI | Interactive dashboard and business reporting |
| Jupyter Notebook | Analysis environment |

---

## 📂 Dataset Description

The project uses a customer shopping behavior dataset containing **3,900 records and 18 original columns**.

The dataset captures customer demographics, purchased products, purchase amounts, reviews, discounts, payment methods, shipping preferences, subscription status, and purchase frequency.

### Key Variables

| Variable | Description |
|---|---|
| `customer_id` | Customer identifier |
| `age` | Customer age |
| `gender` | Customer gender |
| `item_purchased` | Product purchased |
| `category` | Product category |
| `purchase_amount` | Purchase amount in USD |
| `location` | Customer location |
| `size` | Product size |
| `color` | Product color |
| `season` | Season associated with the purchase |
| `review_rating` | Customer review rating |
| `subscription_status` | Whether the customer is subscribed |
| `shipping_type` | Shipping method |
| `discount_applied` | Whether a discount was applied |
| `previous_purchases` | Number of previous purchases |
| `payment_method` | Payment method |
| `frequency_of_purchases` | Reported purchase frequency |

Two additional analytical features were created during preprocessing: `age_group` and `purchase_frequency_days`.

---

## 🔄 Project Workflow

```text
Raw Customer Shopping Dataset
              |
              v
     Python Data Inspection
              |
              v
   Data Cleaning & Transformation
              |
              v
    Feature Engineering
              |
              v
     PostgreSQL Database
              |
              v
       SQL Analysis
              |
              v
      Business Insights
              |
              v
     Power BI Dashboard
```

---

## 🐍 1. Python Data Cleaning & Transformation

Data preprocessing was performed in Jupyter Notebook using Pandas and NumPy.

### Data Inspection

The initial dataset was examined using:

- `head()` to inspect sample records.
- `info()` to review column names, data types, and non-null counts.
- `describe()` to generate descriptive statistics.
- `isnull().sum()` to identify missing values.

### Missing Value Handling

The dataset contained **37 missing values in `Review Rating`**.

Rather than dropping these records, missing ratings were filled using the median review rating within each product category.

```python
data['Review Rating'] = data.groupby('Category')['Review Rating'].transform(
    lambda x: x.fillna(x.median())
)
```

This approach preserves the records while using category-specific information to impute missing ratings.

### Column Standardization

Column names were converted to lowercase and spaces were replaced with underscores. The purchase amount column was renamed to `purchase_amount`.

```python
data.columns = data.columns.str.lower()
data.columns = data.columns.str.replace(' ', '_')

data = data.rename(
    columns={'purchase_amount_(usd)': 'purchase_amount'}
)
```

### Feature Engineering

**Age Group**

Customers were divided into four age groups using `pd.qcut()`:

- Young Adults
- Adult
- Middle-aged
- Senior

```python
labels = ['Young_Adults', 'Adult', 'Middle_aged', 'Senior']

data['age_group'] = pd.qcut(
    data['age'],
    q=4,
    labels=labels
)
```

**Purchase Frequency in Days**

A new variable, `purchase_frequency_days`, was created by mapping purchase-frequency categories to approximate day intervals.

Examples include:

| Purchase Frequency | Mapped Days |
|---|---:|
| Weekly | 7 |
| Fortnightly | 14 |
| Bi-Weekly | 14 |
| Monthly | 30 |
| Quarterly | 90 |
| Annually | 365 |

The notebook also checks whether `discount_applied` and `promo_code_used` contain identical values. Since the comparison returned `True`, `promo_code_used` was removed as redundant.

---

## 🗄️ 2. PostgreSQL Database Integration

The transformed dataset was loaded into a PostgreSQL database using SQLAlchemy and Psycopg2.

### Database Configuration

| Parameter | Value |
|---|---|
| Database | `customer_db` |
| Table | `customer` |
| Host | `localhost` |
| Port | `5432` |

### Data Loading

```python
from sqlalchemy import create_engine

engine = create_engine(
    f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
)

table_name = "customer"

data.to_sql(
    table_name,
    engine,
    if_exists="replace",
    index=False
)
```

The cleaned dataset was successfully loaded into the `customer` table, allowing SQL queries to run against the transformed data.

---

## 📊 3. Business Questions & SQL Analysis

Ten business questions were investigated using PostgreSQL.

### 1. Revenue Contribution by Gender

**Business question:** What is the total revenue generated by male versus female customers?

**SQL concepts:** `SUM()`, `GROUP BY`

The analysis compares total purchase revenue between gender groups.

### 2. Discount Usage and Customer Spending

**Business question:** Which customers used discounts and had total spending greater than the overall average purchase amount?

**SQL concepts:** Subqueries, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`

This query identifies customer records meeting both the discount and spending conditions.

### 3. Top Five Highest-Rated Products

**Business question:** Which five products have the highest average review ratings?

**SQL concepts:** `AVG()`, `ROUND()`, `GROUP BY`, `ORDER BY`, `LIMIT`

The analysis compares average review ratings by product and category.

### 4. Average Purchase Amount by Shipping Type

**Business question:** How do average purchase amounts compare between Standard and Express shipping?

**SQL concepts:** `AVG()`, `ROUND()`, `IN`, `GROUP BY`

This query compares average purchase amounts for the two selected shipping methods.

### 5. Subscription and Spending Analysis

**Business question:** Do subscribed customers spend more than non-subscribed customers?

**SQL concepts:** `COUNT()`, `SUM()`, `AVG()`, `GROUP BY`, `ORDER BY`

The query compares customer counts, total revenue, and average purchase amount by subscription status.

### 6. Discount Rate by Product

**Business question:** Which products have the highest proportion of purchases with discounts applied?

**SQL concepts:** `CASE WHEN`, conditional aggregation, `COUNT()`, `SUM()`

The analysis calculates discount usage rates across purchased products.

### 7. Customer Segmentation

**Business question:** How many customers fall into New, Returning, and Loyal segments?

**SQL concepts:** Common Table Expressions (CTEs), `CASE`, `BETWEEN`, `GROUP BY`

The notebook defines the following segmentation rules:

| Segment | Rule |
|---|---|
| New | 1 previous purchase |
| Returning | 2–10 previous purchases |
| Loyal | More than 10 previous purchases |

### 8. Top Three Products Within Each Category

**Business question:** What are the three most purchased products in each category?

**SQL concepts:** CTEs, `COUNT()`, `ROW_NUMBER()`, `PARTITION BY`

A window function ranks products by order count within each category.

### 9. Repeat Purchasing and Subscription Status

**Business question:** How many customers with more than five previous purchases are subscribers versus non-subscribers?

**SQL concepts:** `WHERE`, `COUNT()`, `GROUP BY`

This analysis examines subscription status among customers with repeat-purchase history.

### 10. Revenue Contribution by Age Group

**Business question:** How much revenue does each customer age group generate?

**SQL concepts:** `SUM()`, `GROUP BY`

The analysis compares total revenue across the four engineered age groups.

---

## 📈 4. Power BI Dashboard

The Power BI report (`Vendor Analysis.pbix`) complements the Python and SQL analysis with visual reporting.

The report includes the following configured visuals:

- **Subscription-wise Customer Analysis:** donut chart showing subscription-related customer distribution.
- **Revenue by Category:** column chart comparing revenue across product categories.
- **Sales by Category:** column chart comparing sales across categories.
- **Revenue by Age Group:** bar chart showing revenue contributions from customer age groups.
- **Sales by Age Group:** bar chart comparing sales across age groups.
- **Interactive Slicers:** filters for exploring the report.

The dashboard is intended to make customer and sales patterns easier to compare visually.

> Open the `.pbix` file using Microsoft Power BI Desktop to interact with the report.

---

## 💡 Key Findings from the Notebook

The following results were observed in the executed SQL queries.

### Revenue by Gender

| Gender | Total Revenue (USD) |
|---|---:|
| Female | $75,191 |
| Male | $157,890 |

Male customers contributed the larger share of total revenue in this dataset.

### Average Purchase Amount by Shipping Type

| Shipping Type | Average Purchase Amount |
|---|---:|
| Express | $60.48 |
| Standard | $58.46 |

Express shipping had the higher average purchase amount in the executed query.

### Subscription Status

| Subscription Status | Customer Records | Total Revenue (USD) | Average Purchase Amount (USD) |
|---|---:|---:|---:|
| No | 2,847 | $170,436 | $59.87 |
| Yes | 1,053 | $62,645 | $59.49 |

The non-subscribed group generated higher total revenue and had a slightly higher average purchase amount in this dataset. These results describe the observed records and do not establish that subscription status causes higher or lower spending.

### Top Five Products by Average Review Rating

| Product | Category | Average Rating |
|---|---|---:|
| Gloves | Accessories | 3.86 |
| Sandals | Footwear | 3.84 |
| Boots | Footwear | 3.82 |
| Hat | Accessories | 3.80 |
| Handbag | Accessories | 3.78 |

### Customer Segmentation

| Segment | Number of Customers |
|---|---:|
| New | 83 |
| Returning | 701 |
| Loyal | 3,116 |

The segmentation query classified the largest number of customer records as Loyal under the notebook's defined rules.

### Revenue by Age Group

| Age Group | Total Revenue (USD) |
|---|---:|
| Young Adults | $62,143 |
| Adult | $55,978 |
| Middle-aged | $59,197 |
| Senior | $55,763 |

Young Adults generated the highest total revenue among the four age groups in the executed query.

---

## 🧠 Skills Demonstrated

### Python & Data Preparation
- Data inspection and profiling
- Missing value imputation
- Column renaming and standardization
- Feature engineering
- Categorical mapping
- Data transformation with Pandas

### SQL & Database Analysis
- Filtering and aggregation
- Conditional logic with `CASE WHEN`
- Subqueries
- Common Table Expressions (CTEs)
- Window functions and ranking
- Customer segmentation
- Revenue and purchase analysis
- PostgreSQL database integration

### Power BI & Reporting
- KPI and category comparisons
- Revenue and sales visualization
- Age-group analysis
- Subscription-related reporting
- Interactive report filtering

### Business Analysis
- Customer behavior analysis
- Revenue contribution analysis
- Product rating analysis
- Discount usage analysis
- Shipping comparison
- Repeat-purchase segmentation

---

## 📁 Repository Structure

```text
Vendor-Analysis/
│
├── Dataset/
│   └── customer_shopping_behavior.csv
│
├── Notebooks/
│   └── Vendor_Analysis.ipynb
│
├── Presentation/
│   └── [Project presentation, if included]
│
├── Visuals/
│   └── [Dashboard screenshots, if included]
│
├── Vendor Analysis.pbix
├── README.md
└── LICENSE
```

*Adjust the folder and file names above to match the exact files uploaded to the repository.*

---

## ▶️ How to Run the Project

### Prerequisites

Install the following software:

- Python
- Jupyter Notebook or JupyterLab
- PostgreSQL
- Microsoft Power BI Desktop (for the dashboard)

### 1. Install Python Libraries

```bash
pip install pandas numpy matplotlib sqlalchemy psycopg2-binary jupyter
```

### 2. Configure PostgreSQL

Create a PostgreSQL database named `customer_db` and configure the connection details in the notebook.

### 3. Update the Dataset Path

Modify the CSV file path in the notebook to match your local dataset location.

```python
data = pd.read_csv("path/to/customer_shopping_behavior.csv")
```

### 4. Run the Notebook

Open `Vendor_Analysis.ipynb` in Jupyter and execute the cells sequentially, from data import and preprocessing through database loading and SQL analysis.

### 5. Open the Power BI Report

Open `Vendor Analysis.pbix` in Power BI Desktop to explore the dashboard.

---

## 🚀 Future Improvements

Potential extensions to this project include:

- Developing a dedicated SQL script containing all business queries.
- Adding KPI cards and more detailed report filters in Power BI.
- Investigating customer retention and purchasing frequency.
- Analyzing discount usage and customer spending across product categories.
- Automating data refresh and reporting.
- Developing a customer spending prediction model.
- Adding statistical tests to assess differences between customer segments.

---

## 👨‍💻 Author

**MD Nur Hossain Joy**

Aspiring Data Analyst | Python | SQL | PostgreSQL | Power BI | Excel
Email: nurhossenjoy72@gmail.com
LinkedIn: https://www.linkedin.com/in/md-nur-hossain-joy-0b0bb9190

**Areas of Interest:** Data Analytics, Business Intelligence, Data Visualization, Customer Analytics, and Machine Learning.

---

## 📜 License

This project is intended for educational and portfolio purposes. Refer to the repository's `LICENSE` file for applicable licensing terms.

---

⭐ If you find this project useful, feel free to star the repository and share your feedback.
