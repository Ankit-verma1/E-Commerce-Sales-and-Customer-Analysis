# 🛒 E-Commerce Sales & Customer Analysis

## 📌 Project Overview

This project analyzes an e-commerce business dataset to understand sales performance, profitability, customer behavior, payment patterns, and product returns.

The project covers the complete data analytics workflow:

**Excel → PostgreSQL → SQL → Power BI**

The final outcome is an interactive Power BI dashboard that provides business insights through KPIs, charts, tables, and slicers.

---

## 🎯 Business Objectives

The main objectives of this project are:

- Analyze overall sales and profit performance
- Identify top-performing product categories
- Identify top products by sales
- Analyze monthly sales trends
- Analyze sales by state
- Understand customer purchasing behavior
- Identify repeat and one-time customers
- Analyze payment methods and payment status
- Analyze product returns and return reasons
- Calculate return rate and profit margin
- Analyze category-wise profitability
- Build an interactive Power BI dashboard

---

## 🛠️ Tools & Technologies

- **Microsoft Excel** – Data cleaning and preprocessing
- **PostgreSQL** – Database management
- **SQL** – Data analysis and business queries
- **Power BI** – Data visualization and dashboard development
- **DAX** – Measures and calculations

---

## 📂 Dataset

The project contains five related tables:

1. `customers`
2. `products`
3. `orders`
4. `payments`
5. `returns`

### Table Relationships

- Customers → Orders
- Products → Orders
- Orders → Payments
- Orders → Returns

The dataset contains:

- 100 Customers
- 30 Products
- 500 Orders
- 500 Payments
- 60 Returns

---

## 🧹 Data Cleaning

Data cleaning was performed in Excel before analysis.

Major cleaning tasks included:

- Removed duplicate customer records
- Trimmed unnecessary spaces
- Standardized state names
- Identified missing values
- Checked data types
- Validated foreign key relationships
- Checked missing order quantities and dates
- Identified invalid discount values

---

## 🗄️ SQL Analysis

The cleaned data was imported into PostgreSQL for analysis.

Some of the SQL concepts used in this project:

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- JOIN
- LEFT JOIN
- CASE
- COALESCE
- Aggregate Functions
- Subqueries
- CTEs
- Window Functions
- DATE_TRUNC
- COUNT
- SUM
- AVG
- DISTINCTCOUNT-equivalent SQL logic

### Key SQL Analysis

The analysis includes:

- Total Sales
- Total Profit
- Profit Margin
- Monthly Sales
- Category-wise Sales
- Top Products
- Top Customers
- Repeat Customers
- State-wise Sales
- Payment Method Analysis
- Payment Status Analysis
- Return Analysis
- Return Rate
- Product Return Rate
- Category Profitability
- Discount Analysis
- Average Order Value

---

## 📊 Power BI Dashboard

The final Power BI dashboard contains:

### KPI Cards

- Total Sales
- Total Profit
- Profit Margin
- Total Orders
- Total Customers
- Total Returns

### Visualizations

- Monthly Sales Trends
- Sales by Category
- Top 5 Products by Sales
- State-wise Sales
- Payment Method Analysis
- Category Profitability
- Customer Analysis
- Return Analysis
- Top Return Reasons

### Interactive Slicers

- Order Date
- Category
- State
- Payment Method

---

## 📈 Key Business Insights

### Sales & Profit

- Total Sales: **₹93,05,563**
- Total Profit: **₹17,19,033**
- Profit Margin: **18.47%**
- Average Order Value: **₹18,611.13**

### Customers

- Total Customers: **100**
- Repeat Customers: **96**
- One-Time Customers: **4**

### Returns

- Total Returns: **60**
- Return Rate: **12%**

Top return reasons:

| Return Reason | Returns |
|---|---:|
| Wrong Product | 12 |
| Damaged | 12 |
| Size Issue | 12 |
| Changed Mind | 9 |
| Late Delivery | 8 |
| Not as Expected | 7 |

### Top Product Categories by Sales

| Category | Sales |
|---|---:|
| Electronics | ₹36,67,240 |
| Furniture | ₹17,93,495 |
| Home Appliances | ₹6,46,405 |
| Sports | ₹4,56,857.50 |
| Fashion | ₹3,43,292.50 |
| Books | ₹56,917 |

---
## 🔄 Project Workflow

```text
Raw Data
   ↓
Excel Data Cleaning
   ↓
PostgreSQL Database
   ↓
SQL Data Analysis
   ↓
Cleaned Data
   ↓
Power BI Data Model
   ↓
DAX Measures
   ↓
Interactive Dashboard
   ↓
Business Insights
