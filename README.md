# Public Service Complaint & Resolution Analytics

## 📌 Project Overview

The **Public Service Complaint & Resolution Analytics** project is a data analytics solution designed to analyze public service complaints and evaluate complaint resolution performance.

The project uses **MySQL** for database management and SQL-based analysis, **Power BI** for interactive dashboard visualization, and **Excel** for supporting data analysis and reporting.

The system helps identify:

- Complaint volume and trends
- Department-wise performance
- Frequently reported complaint categories
- Complaint severity
- Resolution performance
- SLA breaches
- High-priority complaint categories
- Citizen satisfaction

---

## 🎯 Objectives

The main objectives of this project are:

1. Analyze public service complaint data using SQL.
2. Measure complaint resolution performance.
3. Identify departments with resolution bottlenecks.
4. Analyze recurring complaint categories.
5. Identify high-severity and unresolved complaints.
6. Calculate SLA breach rates.
7. Build an interactive Power BI dashboard.
8. Support data-driven decision making through priority-based analysis.

---

## 🛠️ Technologies Used

- **MySQL 8.0** – Database management and SQL analysis
- **SQL** – Joins, aggregations, subqueries, CTEs and window functions
- **Power BI** – Interactive dashboard and data visualization
- **Microsoft Excel** – Data preparation and supporting analysis
- **Git & GitHub** – Version control and project hosting

---

## 🗄️ Database Design

The project uses a relational database named:

`public_service_analytics`

### Tables

The database contains the following tables:

- `departments`
- `categories`
- `locations`
- `citizens`
- `complaints`

### Relationships

The `complaints` table acts as the central transactional table and connects with:

- Departments
- Categories
- Locations
- Citizens

This relational structure allows complaint information to be analyzed across different dimensions.

---

## 📊 Dataset

The project uses a simulated public service complaint dataset containing:

- **8 Departments**
- **24 Complaint Categories**
- **12 Locations**
- **100 Citizens**
- **500 Complaints**

The dataset contains information such as:

- Complaint date
- Resolution date
- Department
- Category
- Location
- Status
- Severity
- Satisfaction score

---

## 🔍 SQL Analysis

SQL was used to perform multiple analytical operations, including:

### Complaint Analysis

- Total complaint volume
- Department-wise complaints
- Category-wise complaints
- City-wise complaints
- Zone-wise complaints
- Monthly complaint trends

### Resolution Analysis

- Average resolution time
- Resolution rate
- Pending complaints
- In-progress complaints
- Unresolved complaint rate

### Severity Analysis

Complaints were classified into:

- Low
- Medium
- High
- Critical

This helps identify complaints requiring greater attention.

### SLA Analysis

Different SLA thresholds were defined based on complaint severity:

| Severity | SLA |
|----------|-----|
| Low | 15 days |
| Medium | 10 days |
| High | 7 days |
| Critical | 5 days |

SLA breach analysis was performed to identify complaints that exceeded their expected resolution time.

---

## 📈 Priority-Based Ranking Model

A priority score was developed to identify complaint categories requiring greater attention.

The model considers:

- **40% Complaint Volume**
- **30% Average Resolution Time**
- **30% High/Critical Complaint Percentage**

This ranking helps identify categories that combine high complaint volume, longer resolution times, and greater severity.

---

## 📊 Power BI Dashboard

The Power BI dashboard provides an interactive view of complaint and resolution performance.

### Executive Overview

The dashboard includes:

- Total Complaints
- Resolved Complaints
- Average Resolution Days
- Resolution Rate
- Department-wise Complaint Analysis
- Monthly Complaint Trend
- Complaints by Severity
- Complaints by Status
- Department Filter
- Severity Filter

### Key KPIs

| KPI | Value |
|-----|------:|
| Total Complaints | 500 |
| Resolved Complaints | 300 |
| Average Resolution Days | 12.89 |
| Resolution Rate | 60% |

---

## 🧮 DAX Measures

Power BI DAX measures were created for important KPIs, including:

- Total Complaints
- Resolved Complaints
- Average Resolution Days
- Resolution Rate
- High/Critical Complaints
- Pending Complaints
- In Progress Complaints
- SLA Breaches
- SLA Breach Rate
- Unresolved Rate
- Average Satisfaction

---

## 📂 Project Structure

```text
Public-Service-Complaint-Analytics
│
├── data
│
├── sql
│   ├── database_design.txt
│   └── public_service_analytics.sql
│
├── powerbi
│   └── public_service_complaint_analytics.pbix
│
├── screenshots
│
└── README.md
