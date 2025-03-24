# 🚴 BikeSales SQL Data Analyst Portfolio Project

## Project Overview
Welcome to my **BikeSales SQL Data Analyst Portfolio Project**, where I demonstrate a comprehensive analysis of BikeSales data using SQL. This portfolio highlights database management and analytical techniques essential for data analysis. The goal is to showcase insights derived from the data while applying key SQL concepts.

---

## Motivation
This project was inspired by the amazing content of [**Baraa Khatib Salkini**](https://www.linkedin.com/in/baraa-khatib-salkini/) on [YouTube](https://www.youtube.com/watch?v=2jGhQpbzHes&t=888s) which motivated me to take a deeper dive into SQL analytics. This portfolio serves as a stepping stone for aspiring data analysts and an example of applying SQL to solve real-world business challenges.

---

## Workflow and Analysis

### 0. **Database Initialization** and **Table Creation** [File Link](scripts/00_init_database.SQL)
- Created the **BikeSales database** and organized it into a structured schema: `gold`.
- Set up relationships between tables to ensure data integrity.
- Designed and created tables to store data including:
  - `sales_orders`
  - `sales_customers`
  - `sales_order_items`
  - `production_products`
  - `production_categories`

### 1. **Bulk Loading** [File Link](scripts/01_bulk_loading.SQL)
- Imported data into the database tables using SQL scripts.
- Ensured the data was cleaned and validated for analysis.

---

## Exploratory Data Analysis
### 2. **Database Exploration** [File Link](scripts/02_database_exploration.SQL)
- Examined the overall structure and schema of the database.
- Reviewed table relationships and constraints.

### 3. **Table Exploration** [File Link](scripts/03_table_exploration.SQL)
- Analyzed individual table structures, column details, and row counts.

### 4. **Date Range Exploration** [File Link](scripts/04_date_range_exploration.SQL)
- Investigated the temporal coverage of the data.
- Identified the earliest and latest transaction dates.

### 5. **Measures Exploration** [File Link](scripts/05_measures_exploration.SQL)
- Calculated key measures such as:
  - Total revenue
  - Total quantity sold
  - Total orders

---

## Advanced Data Analysis
### 6. **Magnitude Analysis** [File Link](scripts/06_magnitude_analysis.SQL)
- Identified entities with the largest contributions:
  - Products with the highest revenue
  - Regions with the most customers

### 7. **Change Over Time Analysis** [File Link](scripts/07_change_over_time_analysis.SQL)
- Conducted **Year-over-Year (YoY)** and **Month-over-Month (MoM)** analyses to study growth and seasonality.

### 8. **Rank Analysis** [File Link](scripts/08_ranking_analysis.SQL)
- Ranked top-performing products, customers, and stores by metrics like sales, quantity sold, and orders.

### 9. **Cumulative Analysis** [File Link](scripts/09_cumulative_analysis.SQL)
- Built cumulative metrics to track progressive growth (e.g., cumulative revenue, cumulative customers).

### 10. **Performance Analysis** [File Link](scripts/10_performace_analysis.SQL)
- Measured performance by identifying high-performing and underperforming entities:
  - Products
  - Customers
  - Stores

### 11. **Part-to-Whole Analysis** [File Link](scripts/11_part_to_whole_analysis.SQL)
- Examined contributions of individual categories and regions to the overall dataset for A/B testing and insights.

### 12. **Data Segmentation** [File Link](scripts/12_data_segmentation.SQL)
- Grouped data into categories:
  - Customer Segmentation: VIP, Regular, New
  - Product Segmentation: High Performer, Mid Performer, Low Performer

---

## Reports
### 13. **Sales Report** [File Link] (scripts/13_sales_report.SQL)
A detailed sales report consolidating customer behaviors and metrics:
- Metrics: Total orders, total sales, total quantity purchased, unique customers, and life span.
- KPIs: Recency (months since last order), Average Order Value (AOV), and Average Monthly Spend.

### 14. **Product Report** [File Link] (scripts/14_product_report.SQL)
A comprehensive product report analyzing product performance:
- Metrics: Total orders, total sales, quantity sold, unique customers, and product lifespan.
- KPIs: Recency (months since last sale), Average Order Revenue (AOR), and Average Monthly Revenue.

---

## Tools and Technologies
- **SQL**: Used for all queries and data analysis.
- **SSMS**: For database management and query execution.
- **GitHub**: Version control and project sharing.
- **Excel/Power BI (Optional)**: For visualization and presentation (not included in the repository).

---

## How to Use
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/BikeSales-SQL-Portfolio.git
