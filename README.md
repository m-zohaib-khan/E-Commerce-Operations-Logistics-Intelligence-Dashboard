# Brazilian E-Commerce Operations & Logistics Intelligence Dashboard

An executive-level, 3-page interactive Microsoft Power BI analytics solution engineered to evaluate enterprise revenue trajectories, isolate margin erosion driven by freight expenditures, and resolve regional supply chain fulfillment bottlenecks across Brazil.

---

## 📌 Problem Statement

An e-commerce business reported **23% year-over-year
revenue growth** but simultaneously experienced an
**8% decline in net profit**. Senior management had
no visibility into which product categories, customer
regions, or time periods were responsible for this
growing profit-revenue gap.

**Business Question:**
> *"Which product categories, customer regions, and
> time periods are driving revenue growth but
> destroying profit margin through freight costs?"*

---

## Executive Summary

* **Gross Revenue:** **$13.22M** generated across **96K** fulfilled customer orders.
* **Freight Expenditure:** **$2.20M** total shipping cost, establishing an aggregate **14.3% freight-to-revenue overhead rate**.
* **Direct Margin Opportunity:** **$894.35K** in recoverable freight expenditure identified by targeting high-volume, low-margin bulky product categories.
* **Geographic Fulfillment Gap:** Core revenue is centered in São Paulo (SP) (**$5.07M**) with an optimal **8.8-day** delivery cycle, whereas northern regions like Roraima (RR) face operational friction up to **29.4 days**.
* **Demand Dynamics:** Consumer purchasing activity heavily surges on **Monday ($2,169K)** and drops by **~32.5%** over the weekend (**Saturday at $1,464K**).

---

## Business Problem & Strategic Objectives

1. **Margin Erosion:** Disproportionate freight costs in key categories deplete net margins despite strong gross sales.
2. **Fulfillment Disparities:** Severe regional delivery delays in outlying Brazilian states lower customer retention and satisfaction.
3. **Operational Misalignment:** Marketing ad spend and logistics staffing are out of sync with early-week order volume spikes.

---

## Dashboard Architecture & Visual Overview

### Page 1: Executive Sales & Freight Overview
<img width="1026" height="742" alt="Screenshot 2026-09-02 214055" src="https://github.com/user-attachments/assets/f26031ef-25f9-42a4-ab8e-5baae066513e" />

* **Focus:** High-level executive KPIs, multi-year revenue trends, product category contributions, and initial freight cost distribution.
* **Key Findings:**
  * Top revenue drivers are **Health & Beauty ($1.23M)** and **Watches & Gifts ($1.17M)**.
  * Product lines such as **Diapers & Hygiene (26.7%)** and **CDs/DVDs (23.6%)** consume excessive freight costs relative to sales volume.

---

### Page 2: Revenue vs. Freight Gap Intelligence
<img width="1211" height="750" alt="Screenshot 2026-09-02 214111" src="https://github.com/user-attachments/assets/d18e16d2-f4b3-45a0-becc-e7f083795dc9" />

* **Focus:** Category margin efficiency, scatter plot quadrant analysis, revenue rank vs. freight rank disparity, and margin leakage.
* **Key Findings:**
  * **Watches & Gifts** operates at high margin efficiency (**8.4% freight rate**), whereas **Bed, Bath & Table** suffers from severe shipping inefficiency (**19.7% freight rate**).
  * Uncovers **$894.35K** in actionable freight optimization by enforcing Minimum Order Values (MOV) and renegotiating carrier rates for heavy item categories.

---

### Page 3: Regional & Time Intelligence
<img width="1412" height="742" alt="Screenshot 2026-09-02 214143" src="https://github.com/user-attachments/assets/6cab305e-f285-47ca-b364-bbcd6a244cc6" />

* **Focus:** Choropleth map analysis, region-by-region fulfillment benchmarks against SP (8.7 days), and a Day × Month purchasing heatmap.
* **Key Findings:**
  * Displays a clear geographic operational split: Southern states deliver in <10 days, while Northern/Northeastern states average 19–29 days.
  * **Day × Month Matrix Heatmap:** Pinpoints Monday as the top revenue day across all 12 calendar months, while highlighting Q2 seasonal volume dips in April and June.

---

## Technical Stack & Data Modeling

* **Business Intelligence Engine:** Microsoft Power BI Desktop
* **Data Foundation:** Brazilian E-Commerce Public Dataset (`dim_customer`, `dim_date`, `fact_orders`, `fact_order_items`)
* **Design & Theme System:**
  * **Typography:** Segoe UI
  * **Color Palette:** Dark Navy (`#1A1A2E`), Primary Blue (`#3498DB`), Accent Red (`#E74C3C`), Success Green (`#2ECC71`), Neutral Gray (`#F8F9FA`)
* **Core DAX Calculations:**
  * `[Total Revenue]` = `SUM(fact_order_items[price])`
  * `[Total Freight Cost]` = `SUM(fact_order_items[freight_value])`
  * `[Freight Rate %]` = `DIVIDE([Total Freight Cost], [Total Revenue], 0)`
  * `[Avg Delivery Days]` = `AVERAGE(fact_orders[delivery_duration_days])`
  * `[Late Delivery Rate %]` = `DIVIDE([Late Orders Count], [Total Orders], 0)`

---

## Interactive Enterprise Features

* **Cross-Page Slicer Synchronization:** Year, Quarter, and Region parameters remain fully synchronized across all 3 pages.
* **Contextual Drillthrough Navigation:** Built-in drillthrough allows users to right-click any region on Page 1 or Page 2 to immediately navigate to a localized Page 3 view.
* **Dynamic Conditional Formatting:** Rules-based color scales automatically highlight margin risks, delivery delay breaches, and purchasing demand peaks.

## 🛠️ Tools & Technologies

| Tool | Purpose | Version |
|------|---------|---------|
| **MySQL** | Data storage & SQL analysis | 8.0 |
| **Python** | Data cleaning & EDA | 3.11 |
| **Pandas** | Data manipulation | 2.0 |
| **Matplotlib/Seaborn** | EDA visualizations | Latest |
| **Power BI** | Interactive dashboard | Desktop |
| **Excel** | Executive summary report | 2021 |
| **Git/GitHub** | Version control | Latest |

---

## 📊 Dataset

| Property | Details |
|----------|---------|
| **Source** | [Brazilian E-Commerce — Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) |
| **Size** | 96,478 delivered orders |
| **Period** | September 2016 — August 2018 |
| **Tables** | 7 CSV files joined via order_id |
| **Domain** | E-Commerce / Retail Finance |

**Files used:**
