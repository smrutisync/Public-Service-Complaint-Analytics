/* ============================================================
   PUBLIC SERVICE COMPLAINT & RESOLUTION ANALYTICS
   Complete MySQL Project
   ============================================================ */


/* ============================================================
   PART 1: DATABASE SETUP
   ============================================================ */

DROP DATABASE IF EXISTS public_service_analytics;

CREATE DATABASE public_service_analytics;

USE public_service_analytics;


/* ============================================================
   PART 2: CREATE TABLES
   ============================================================ */


/* ----------------------------
   1. DEPARTMENTS
   ---------------------------- */

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);


/* ----------------------------
   2. CATEGORIES
   ---------------------------- */

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    department_id INT NOT NULL,
    category_name VARCHAR(100) NOT NULL UNIQUE,

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);


/* ----------------------------
   3. LOCATIONS
   ---------------------------- */

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    zone VARCHAR(100) NOT NULL
);


/* ----------------------------
   4. CITIZENS
   ---------------------------- */

CREATE TABLE citizens (
    citizen_id INT PRIMARY KEY,
    age_group VARCHAR(20) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    location_id INT NOT NULL,

    FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
);


/* ----------------------------
   5. COMPLAINTS
   ---------------------------- */

CREATE TABLE complaints (
    complaint_id INT PRIMARY KEY,

    citizen_id INT NOT NULL,

    department_id INT NOT NULL,

    category_id INT NOT NULL,

    location_id INT NOT NULL,

    complaint_date DATE NOT NULL,

    resolution_date DATE NULL,

    status VARCHAR(20) NOT NULL,

    severity VARCHAR(20) NOT NULL,

    satisfaction_score INT NULL,

    FOREIGN KEY (citizen_id)
        REFERENCES citizens(citizen_id),

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id),

    FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    FOREIGN KEY (location_id)
        REFERENCES locations(location_id),

    CHECK (
        status IN ('Resolved', 'Pending', 'In Progress')
    ),

    CHECK (
        severity IN ('Low', 'Medium', 'High', 'Critical')
    ),

    CHECK (
        satisfaction_score IS NULL
        OR satisfaction_score BETWEEN 1 AND 5
    )
);


/* ============================================================
   PART 3: INSERT DEPARTMENTS
   ============================================================ */

INSERT INTO departments
    (department_id, department_name)
VALUES
    (1, 'Water Supply'),
    (2, 'Electricity'),
    (3, 'Roads & Infrastructure'),
    (4, 'Waste Management'),
    (5, 'Public Health'),
    (6, 'Public Transport'),
    (7, 'Sanitation'),
    (8, 'Street Lighting');


/* ============================================================
   PART 4: INSERT CATEGORIES
   ============================================================ */

INSERT INTO categories
    (category_id, department_id, category_name)
VALUES

    /* Water Supply */
    (1, 1, 'Water Leakage'),
    (2, 1, 'No Water Supply'),
    (3, 1, 'Water Quality'),

    /* Electricity */
    (4, 2, 'Power Outage'),
    (5, 2, 'Voltage Fluctuation'),
    (6, 2, 'Damaged Electric Pole'),

    /* Roads */
    (7, 3, 'Potholes'),
    (8, 3, 'Road Damage'),
    (9, 3, 'Traffic Signal Issue'),

    /* Waste */
    (10, 4, 'Garbage Collection'),
    (11, 4, 'Illegal Dumping'),
    (12, 4, 'Waste Disposal'),

    /* Public Health */
    (13, 5, 'Health Center Issue'),
    (14, 5, 'Medicine Availability'),
    (15, 5, 'Public Health Complaint'),

    /* Transport */
    (16, 6, 'Bus Delay'),
    (17, 6, 'Bus Route Issue'),
    (18, 6, 'Public Transport Condition'),

    /* Sanitation */
    (19, 7, 'Drainage Issue'),
    (20, 7, 'Sewage Problem'),
    (21, 7, 'Public Toilet Issue'),

    /* Street Lighting */
    (22, 8, 'Street Light Not Working'),
    (23, 8, 'Damaged Street Light'),
    (24, 8, 'Dark Area Complaint');


/* ============================================================
   PART 5: INSERT LOCATIONS
   ============================================================ */

INSERT INTO locations
    (location_id, city, zone)
VALUES
    (1, 'Bhubaneswar', 'North'),
    (2, 'Bhubaneswar', 'South'),
    (3, 'Bhubaneswar', 'East'),
    (4, 'Bhubaneswar', 'West'),

    (5, 'Cuttack', 'North'),
    (6, 'Cuttack', 'South'),
    (7, 'Cuttack', 'East'),
    (8, 'Cuttack', 'West'),

    (9, 'Puri', 'North'),
    (10, 'Puri', 'South'),
    (11, 'Puri', 'East'),
    (12, 'Puri', 'West');


/* ============================================================
   PART 6: INSERT 100 CITIZENS
   ============================================================ */

INSERT INTO citizens
    (citizen_id, age_group, gender, location_id)

WITH RECURSIVE citizen_numbers AS (

    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM citizen_numbers
    WHERE n < 100
)

SELECT
    n,

    CASE
        WHEN MOD(n, 4) = 0 THEN '18-25'
        WHEN MOD(n, 4) = 1 THEN '26-35'
        WHEN MOD(n, 4) = 2 THEN '36-50'
        ELSE '51+'
    END,

    CASE
        WHEN MOD(n, 3) = 0 THEN 'Female'
        WHEN MOD(n, 3) = 1 THEN 'Male'
        ELSE 'Other'
    END,

    MOD(n - 1, 12) + 1

FROM citizen_numbers;


/* ============================================================
   PART 7: INSERT 500 COMPLAINTS
   ============================================================ */

INSERT INTO complaints
(
    complaint_id,
    citizen_id,
    department_id,
    category_id,
    location_id,
    complaint_date,
    resolution_date,
    status,
    severity,
    satisfaction_score
)

WITH RECURSIVE complaint_numbers AS (

    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM complaint_numbers
    WHERE n < 500
)

SELECT

    /* Complaint ID */
    n,

    /* Citizen */
    MOD(n - 1, 100) + 1,

    /* Department based on category */
    FLOOR((MOD(n - 1, 24)) / 3) + 1,

    /* Category */
    MOD(n - 1, 24) + 1,

    /* Location */
    MOD(MOD(n - 1, 100), 12) + 1,

    /* Complaint Date */
    DATE_ADD(
        '2025-01-01',
        INTERVAL MOD(n * 7, 610) DAY
    ),

    /* Resolution Date */
    CASE

        /* Pending complaints */
        WHEN MOD(n, 10) IN (0, 1)
        THEN NULL

        /* In Progress complaints */
        WHEN MOD(n, 10) IN (2, 3)
        THEN NULL

        /* Resolved complaints */
        ELSE DATE_ADD(
            DATE_ADD(
                '2025-01-01',
                INTERVAL MOD(n * 7, 610) DAY
            ),

            INTERVAL
            CASE
                /* Water */
                WHEN FLOOR((MOD(n - 1, 24)) / 3) + 1 = 1
                    THEN 2 + MOD(n * 3, 10)

                /* Electricity */
                WHEN FLOOR((MOD(n - 1, 24)) / 3) + 1 = 2
                    THEN 3 + MOD(n * 4, 15)

                /* Roads */
                WHEN FLOOR((MOD(n - 1, 24)) / 3) + 1 = 3
                    THEN 7 + MOD(n * 5, 25)

                /* Waste */
                WHEN FLOOR((MOD(n - 1, 24)) / 3) + 1 = 4
                    THEN 4 + MOD(n * 3, 18)

                /* Public Health */
                WHEN FLOOR((MOD(n - 1, 24)) / 3) + 1 = 5
                    THEN 5 + MOD(n * 4, 20)

                /* Transport */
                WHEN FLOOR((MOD(n - 1, 24)) / 3) + 1 = 6
                    THEN 6 + MOD(n * 5, 22)

                /* Sanitation */
                WHEN FLOOR((MOD(n - 1, 24)) / 3) + 1 = 7
                    THEN 5 + MOD(n * 4, 20)

                /* Street Lighting */
                ELSE
                    3 + MOD(n * 3, 15)
            END DAY
        )

    END,

    /* Status */
    CASE
        WHEN MOD(n, 10) IN (0, 1)
            THEN 'Pending'

        WHEN MOD(n, 10) IN (2, 3)
            THEN 'In Progress'

        ELSE 'Resolved'
    END,

    /* Severity */
    CASE
        WHEN MOD(n, 20) IN (0, 1)
            THEN 'Critical'

        WHEN MOD(n, 20) BETWEEN 2 AND 6
            THEN 'High'

        WHEN MOD(n, 20) BETWEEN 7 AND 12
            THEN 'Medium'

        ELSE 'Low'
    END,

    /* Satisfaction */
    CASE
        WHEN MOD(n, 10) IN (0, 1, 2, 3)
            THEN NULL

        ELSE
            MOD(n * 7, 5) + 1
    END

FROM complaint_numbers;


/* ============================================================
   PART 8: CREATE INDEXES
   ============================================================ */

CREATE INDEX idx_complaints_department
ON complaints(department_id);

CREATE INDEX idx_complaints_category
ON complaints(category_id);

CREATE INDEX idx_complaints_location
ON complaints(location_id);

CREATE INDEX idx_complaints_status
ON complaints(status);

CREATE INDEX idx_complaints_severity
ON complaints(severity);

CREATE INDEX idx_complaints_date
ON complaints(complaint_date);


/* ============================================================
   PART 9: ANALYTICAL VIEW
   ============================================================ */

CREATE VIEW vw_complaint_analytics AS

SELECT

    c.complaint_id,

    c.complaint_date,

    c.resolution_date,

    c.status,

    c.severity,

    c.satisfaction_score,

    d.department_name,

    cat.category_name,

    l.city,

    l.zone,

    ci.age_group,

    ci.gender,

    CASE
        WHEN c.resolution_date IS NOT NULL
        THEN DATEDIFF(
            c.resolution_date,
            c.complaint_date
        )
        ELSE NULL
    END AS resolution_days,

    CASE
        WHEN c.severity = 'Critical' THEN 4
        WHEN c.severity = 'High' THEN 3
        WHEN c.severity = 'Medium' THEN 2
        ELSE 1
    END AS severity_weight

FROM complaints c

JOIN departments d
    ON c.department_id = d.department_id

JOIN categories cat
    ON c.category_id = cat.category_id

JOIN locations l
    ON c.location_id = l.location_id

JOIN citizens ci
    ON c.citizen_id = ci.citizen_id;


/* ============================================================
   PART 10: BASIC DATA VALIDATION
   ============================================================ */


/* Number of departments */

SELECT COUNT(*) AS total_departments
FROM departments;


/* Number of categories */

SELECT COUNT(*) AS total_categories
FROM categories;


/* Number of citizens */

SELECT COUNT(*) AS total_citizens
FROM citizens;


/* Number of complaints */

SELECT COUNT(*) AS total_complaints
FROM complaints;


/* ============================================================
   PART 11: OVERALL KPI
   ============================================================ */

SELECT

    COUNT(*) AS total_complaints,

    SUM(
        status = 'Resolved'
    ) AS resolved_complaints,

    SUM(
        status = 'Pending'
    ) AS pending_complaints,

    SUM(
        status = 'In Progress'
    ) AS in_progress_complaints,

    ROUND(
        100 * SUM(status = 'Resolved')
        / COUNT(*),
        2
    ) AS resolution_rate,

    ROUND(
        AVG(
            CASE
                WHEN resolution_date IS NOT NULL
                THEN DATEDIFF(
                    resolution_date,
                    complaint_date
                )
            END
        ),
        2
    ) AS average_resolution_days,

    ROUND(
        AVG(satisfaction_score),
        2
    ) AS average_satisfaction

FROM complaints;


/* ============================================================
   PART 12: DEPARTMENT PERFORMANCE
   ============================================================ */

SELECT

    d.department_name,

    COUNT(c.complaint_id) AS total_complaints,

    SUM(
        c.status = 'Resolved'
    ) AS resolved_complaints,

    SUM(
        c.status IN ('Pending', 'In Progress')
    ) AS unresolved_complaints,

    ROUND(
        100 * SUM(c.status = 'Resolved')
        / COUNT(c.complaint_id),
        2
    ) AS resolution_rate,

    ROUND(
        AVG(
            CASE
                WHEN c.resolution_date IS NOT NULL
                THEN DATEDIFF(
                    c.resolution_date,
                    c.complaint_date
                )
            END
        ),
        2
    ) AS avg_resolution_days,

    ROUND(
        AVG(c.satisfaction_score),
        2
    ) AS avg_satisfaction

FROM departments d

LEFT JOIN complaints c
    ON d.department_id = c.department_id

GROUP BY
    d.department_id,
    d.department_name

ORDER BY
    avg_resolution_days DESC;


/* ============================================================
   PART 13: CATEGORY-WISE RECURRING ISSUES
   ============================================================ */

SELECT

    cat.category_name,

    d.department_name,

    COUNT(c.complaint_id) AS complaint_count,

    SUM(
        c.status != 'Resolved'
    ) AS unresolved_count,

    ROUND(
        AVG(
            CASE
                WHEN c.resolution_date IS NOT NULL
                THEN DATEDIFF(
                    c.resolution_date,
                    c.complaint_date
                )
            END
        ),
        2
    ) AS avg_resolution_days

FROM complaints c

JOIN categories cat
    ON c.category_id = cat.category_id

JOIN departments d
    ON c.department_id = d.department_id

GROUP BY

    cat.category_id,
    cat.category_name,
    d.department_name

ORDER BY
    complaint_count DESC;


/* ============================================================
   PART 14: CITY-WISE ANALYSIS
   ============================================================ */

SELECT

    l.city,

    COUNT(c.complaint_id) AS total_complaints,

    SUM(
        c.status = 'Resolved'
    ) AS resolved,

    SUM(
        c.status != 'Resolved'
    ) AS unresolved,

    ROUND(
        AVG(
            CASE
                WHEN c.resolution_date IS NOT NULL
                THEN DATEDIFF(
                    c.resolution_date,
                    c.complaint_date
                )
            END
        ),
        2
    ) AS avg_resolution_days

FROM complaints c

JOIN locations l
    ON c.location_id = l.location_id

GROUP BY
    l.city

ORDER BY
    total_complaints DESC;


/* ============================================================
   PART 15: ZONE-WISE ANALYSIS
   ============================================================ */

SELECT

    l.zone,

    COUNT(*) AS total_complaints,

    SUM(
        c.status = 'Resolved'
    ) AS resolved,

    ROUND(
        100 * SUM(c.status = 'Resolved')
        / COUNT(*),
        2
    ) AS resolution_rate

FROM complaints c

JOIN locations l
    ON c.location_id = l.location_id

GROUP BY
    l.zone

ORDER BY
    resolution_rate ASC;


/* ============================================================
   PART 16: SEVERITY ANALYSIS
   ============================================================ */

SELECT

    severity,

    COUNT(*) AS complaint_count,

    SUM(
        status = 'Resolved'
    ) AS resolved_count,

    SUM(
        status != 'Resolved'
    ) AS unresolved_count,

    ROUND(
        100 * SUM(status = 'Resolved')
        / COUNT(*),
        2
    ) AS resolution_rate

FROM complaints

GROUP BY severity

ORDER BY
    CASE severity
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END;


/* ============================================================
   PART 17: MONTHLY COMPLAINT TREND
   ============================================================ */

SELECT

    DATE_FORMAT(
        complaint_date,
        '%Y-%m'
    ) AS complaint_month,

    COUNT(*) AS total_complaints,

    SUM(
        status = 'Resolved'
    ) AS resolved,

    SUM(
        status != 'Resolved'
    ) AS unresolved

FROM complaints

GROUP BY
    DATE_FORMAT(
        complaint_date,
        '%Y-%m'
    )

ORDER BY
    complaint_month;


/* ============================================================
   PART 18: MONTHLY DEPARTMENT PERFORMANCE
   ============================================================ */

SELECT

    DATE_FORMAT(
        c.complaint_date,
        '%Y-%m'
    ) AS complaint_month,

    d.department_name,

    COUNT(*) AS total_complaints,

    ROUND(
        AVG(
            CASE
                WHEN c.resolution_date IS NOT NULL
                THEN DATEDIFF(
                    c.resolution_date,
                    c.complaint_date
                )
            END
        ),
        2
    ) AS avg_resolution_days

FROM complaints c

JOIN departments d
    ON c.department_id = d.department_id

GROUP BY

    DATE_FORMAT(
        c.complaint_date,
        '%Y-%m'
    ),

    d.department_name

ORDER BY
    complaint_month,
    avg_resolution_days DESC;


/* ============================================================
   PART 19: HIGH IMPACT COMPLAINTS
   ============================================================ */

SELECT

    complaint_id,

    department_name,

    category_name,

    city,

    severity,

    status,

    complaint_date,

    resolution_date,

    resolution_days,

    satisfaction_score

FROM vw_complaint_analytics

WHERE severity IN ('Critical', 'High')

ORDER BY

    CASE severity
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
    END,

    resolution_days DESC;


/* ============================================================
   PART 20: SLA BREACH ANALYSIS
   ============================================================ */

/*
   Assumed SLA:
   Low       = 15 days
   Medium    = 10 days
   High      = 7 days
   Critical  = 5 days
*/

SELECT

    complaint_id,

    department_name,

    category_name,

    severity,

    status,

    resolution_days,

    CASE

        WHEN severity = 'Critical'
             AND resolution_days > 5
            THEN 'SLA Breach'

        WHEN severity = 'High'
             AND resolution_days > 7
            THEN 'SLA Breach'

        WHEN severity = 'Medium'
             AND resolution_days > 10
            THEN 'SLA Breach'

        WHEN severity = 'Low'
             AND resolution_days > 15
            THEN 'SLA Breach'

        ELSE 'Within SLA'

    END AS sla_status

FROM vw_complaint_analytics

WHERE resolution_days IS NOT NULL

ORDER BY
    resolution_days DESC;


/* ============================================================
   PART 21: DEPARTMENT SLA PERFORMANCE
   ============================================================ */

SELECT

    department_name,

    COUNT(*) AS resolved_complaints,

    SUM(

        CASE

            WHEN severity = 'Critical'
                 AND resolution_days > 5
                THEN 1

            WHEN severity = 'High'
                 AND resolution_days > 7
                THEN 1

            WHEN severity = 'Medium'
                 AND resolution_days > 10
                THEN 1

            WHEN severity = 'Low'
                 AND resolution_days > 15
                THEN 1

            ELSE 0

        END

    ) AS sla_breaches,

    ROUND(

        100 *

        SUM(

            CASE

                WHEN

                    (severity = 'Critical'
                     AND resolution_days > 5)

                    OR

                    (severity = 'High'
                     AND resolution_days > 7)

                    OR

                    (severity = 'Medium'
                     AND resolution_days > 10)

                    OR

                    (severity = 'Low'
                     AND resolution_days > 15)

                THEN 1

                ELSE 0

            END

        )

        / COUNT(*),

        2

    ) AS sla_breach_rate

FROM vw_complaint_analytics

WHERE resolution_days IS NOT NULL

GROUP BY
    department_name

ORDER BY
    sla_breach_rate DESC;


/* ============================================================
   PART 22: WINDOW FUNCTION
   Rank departments by average resolution time
   ============================================================ */

WITH department_performance AS (

    SELECT

        d.department_name,

        COUNT(c.complaint_id)
            AS total_complaints,

        ROUND(

            AVG(

                CASE

                    WHEN c.resolution_date IS NOT NULL

                    THEN DATEDIFF(
                        c.resolution_date,
                        c.complaint_date
                    )

                END

            ),

            2

        ) AS avg_resolution_days

    FROM departments d

    JOIN complaints c

        ON d.department_id = c.department_id

    GROUP BY

        d.department_id,
        d.department_name
)

SELECT

    department_name,

    total_complaints,

    avg_resolution_days,

    RANK() OVER (

        ORDER BY
            avg_resolution_days DESC

    ) AS bottleneck_rank

FROM department_performance

ORDER BY
    bottleneck_rank;


/* ============================================================
   PART 23: CATEGORY PRIORITY RANKING MODEL
   ============================================================ */

/*
   Priority Score considers:

   40% = Complaint volume
   30% = Average resolution time
   30% = High/Critical complaint percentage
*/

WITH category_metrics AS (

    SELECT

        cat.category_name,

        d.department_name,

        COUNT(c.complaint_id)
            AS complaint_count,

        ROUND(

            AVG(

                CASE

                    WHEN c.resolution_date IS NOT NULL

                    THEN DATEDIFF(
                        c.resolution_date,
                        c.complaint_date
                    )

                END

            ),

            2

        ) AS avg_resolution_days,

        ROUND(

            100 *

            SUM(

                c.severity IN
                ('High', 'Critical')

            )

            / COUNT(*),

            2

        ) AS high_impact_percentage

    FROM complaints c

    JOIN categories cat

        ON c.category_id = cat.category_id

    JOIN departments d

        ON c.department_id = d.department_id

    GROUP BY

        cat.category_id,

        cat.category_name,

        d.department_name
),

normalized_metrics AS (

    SELECT

        *,

        complaint_count
        /

        MAX(complaint_count)
        OVER ()

        AS volume_score,

        avg_resolution_days
        /

        MAX(avg_resolution_days)
        OVER ()

        AS resolution_score,

        high_impact_percentage
        /

        MAX(high_impact_percentage)
        OVER ()

        AS severity_score

    FROM category_metrics
),

priority_model AS (

    SELECT

        *,

        ROUND(

            (

                volume_score * 0.40

            )

            +

            (

                resolution_score * 0.30

            )

            +

            (

                severity_score * 0.30

            ),

            4

        ) AS priority_score

    FROM normalized_metrics
)

SELECT

    category_name,

    department_name,

    complaint_count,

    avg_resolution_days,

    high_impact_percentage,

    priority_score,

    RANK() OVER (

        ORDER BY
            priority_score DESC

    ) AS priority_rank

FROM priority_model

ORDER BY
    priority_rank;


/* ============================================================
   PART 24: TOP 10 HIGH-PRIORITY CATEGORIES
   ============================================================ */

WITH category_metrics AS (

    SELECT

        cat.category_name,

        d.department_name,

        COUNT(*) AS complaint_count,

        AVG(

            CASE

                WHEN c.resolution_date IS NOT NULL

                THEN DATEDIFF(
                    c.resolution_date,
                    c.complaint_date
                )

            END

        ) AS avg_resolution_days,

        100 *

        SUM(

            c.severity IN
            ('High', 'Critical')

        )

        / COUNT(*) AS high_impact_percentage

    FROM complaints c

    JOIN categories cat

        ON c.category_id = cat.category_id

    JOIN departments d

        ON c.department_id = d.department_id

    GROUP BY

        cat.category_id,

        cat.category_name,

        d.department_name
),

scores AS (

    SELECT

        *,

        complaint_count
        / MAX(complaint_count)
        OVER () AS volume_score,

        avg_resolution_days
        / MAX(avg_resolution_days)
        OVER () AS resolution_score,

        high_impact_percentage
        / MAX(high_impact_percentage)
        OVER () AS severity_score

    FROM category_metrics
)

SELECT

    category_name,

    department_name,

    complaint_count,

    ROUND(avg_resolution_days, 2)
        AS avg_resolution_days,

    ROUND(high_impact_percentage, 2)
        AS high_impact_percentage,

    ROUND(

        volume_score * 0.40
        +

        resolution_score * 0.30
        +

        severity_score * 0.30,

        4

    ) AS priority_score

FROM scores

ORDER BY
    priority_score DESC

LIMIT 10;


/* ============================================================
   PART 25: TOP BOTTLENECK DEPARTMENTS
   ============================================================ */

SELECT

    department_name,

    COUNT(*) AS total_complaints,

    ROUND(

        AVG(resolution_days),

        2

    ) AS avg_resolution_days,

    SUM(

        status != 'Resolved'

    ) AS unresolved_complaints,

    ROUND(

        100 *

        SUM(status != 'Resolved')

        / COUNT(*),

        2

    ) AS unresolved_rate

FROM vw_complaint_analytics

GROUP BY
    department_name

ORDER BY

    unresolved_rate DESC,

    avg_resolution_days DESC;


/* ============================================================
   PART 26: CUSTOMER SATISFACTION BY DEPARTMENT
   ============================================================ */

SELECT

    department_name,

    COUNT(satisfaction_score)
        AS rated_complaints,

    ROUND(

        AVG(satisfaction_score),

        2

    ) AS avg_satisfaction,

    MIN(satisfaction_score)
        AS lowest_rating,

    MAX(satisfaction_score)
        AS highest_rating

FROM vw_complaint_analytics

GROUP BY
    department_name

ORDER BY
    avg_satisfaction ASC;


/* ============================================================
   PART 27: HIGH-SEVERITY UNRESOLVED COMPLAINTS
   ============================================================ */

SELECT

    complaint_id,

    department_name,

    category_name,

    city,

    zone,

    severity,

    status,

    complaint_date

FROM vw_complaint_analytics

WHERE

    severity IN ('High', 'Critical')

    AND status != 'Resolved'

ORDER BY

    CASE severity

        WHEN 'Critical' THEN 1

        WHEN 'High' THEN 2

    END,

    complaint_date;


/* ============================================================
   PART 28: FINAL DATA CHECK
   ============================================================ */

SELECT
    'Departments' AS table_name,
    COUNT(*) AS row_count
FROM departments

UNION ALL

SELECT
    'Categories',
    COUNT(*)
FROM categories

UNION ALL

SELECT
    'Locations',
    COUNT(*)
FROM locations

UNION ALL

SELECT
    'Citizens',
    COUNT(*)
FROM citizens

UNION ALL

SELECT
    'Complaints',
    COUNT(*)
FROM complaints;