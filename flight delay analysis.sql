CREATE TABLE flights (
    fl_date DATE,
    airline VARCHAR(100),
    airline_dot VARCHAR(150),
    airline_code VARCHAR(10),
    dot_code INTEGER,
    fl_number INTEGER,
    origin VARCHAR(10),
    origin_city VARCHAR(100),
    dest VARCHAR(10),
    dest_city VARCHAR(100),
    crs_dep_time INTEGER,
    dep_time NUMERIC,
    dep_delay NUMERIC,
    taxi_out NUMERIC,
    wheels_off NUMERIC,
    wheels_on NUMERIC,
    taxi_in NUMERIC,
    crs_arr_time INTEGER,
    arr_time NUMERIC,
    arr_delay NUMERIC,
    cancelled NUMERIC,
    cancellation_code VARCHAR(5),
    diverted NUMERIC,
    crs_elapsed_time NUMERIC,
    elapsed_time NUMERIC,
    air_time NUMERIC,
    distance NUMERIC,
    delay_due_carrier NUMERIC,
    delay_due_weather NUMERIC,
    delay_due_nas NUMERIC,
    delay_due_security NUMERIC,
    delay_due_late_aircraft NUMERIC
);


SELECT COUNT(*) FROM flights;

SELECT cancelled, COUNT(*)
FROM flights
GROUP BY cancelled;

SELECT COUNT(*)
FROM flights
WHERE dep_delay IS NULL;

--Q1: Airline-wise average departure delay

SELECT 
     airline,
     ROUND(AVG(dep_delay),2) as avg_departure_delay,
	 COUNT(*) AS total_flights
FROM flights
WHERE cancelled=0
GROUP BY airline
ORDER BY avg_departure_delay DESC;

--Q2: Top 10 most delayed routes 

SELECT 
    origin,
    dest,
    ROUND(AVG(dep_delay), 2) AS avg_delay,
    COUNT(*) AS total_flights
FROM flights
WHERE cancelled = 0
GROUP BY origin, dest
HAVING COUNT(*) > 20
ORDER BY avg_delay DESC
LIMIT 10;

-- Q3: Month-wise Average Delay Trend

SELECT
    EXTRACT(MONTH FROM fl_date) AS month,
    ROUND(AVG(dep_delay), 2) AS avg_delay,
    COUNT(*) AS total_flights
FROM flights
WHERE cancelled = 0
GROUP BY EXTRACT(MONTH FROM fl_date)
ORDER BY month;

-- Q4: Delay contribution by cause(%)

SELECT
    ROUND(100.0 * SUM(delay_due_carrier)       / SUM(delay_due_carrier + delay_due_weather + delay_due_nas + delay_due_security + delay_due_late_aircraft), 2) AS carrier_pct,
    ROUND(100.0 * SUM(delay_due_weather)       / SUM(delay_due_carrier + delay_due_weather + delay_due_nas + delay_due_security + delay_due_late_aircraft), 2) AS weather_pct,
    ROUND(100.0 * SUM(delay_due_nas)           / SUM(delay_due_carrier + delay_due_weather + delay_due_nas + delay_due_security + delay_due_late_aircraft), 2) AS nas_pct,
    ROUND(100.0 * SUM(delay_due_security)      / SUM(delay_due_carrier + delay_due_weather + delay_due_nas + delay_due_security + delay_due_late_aircraft), 2) AS security_pct,
    ROUND(100.0 * SUM(delay_due_late_aircraft) / SUM(delay_due_carrier + delay_due_weather + delay_due_nas + delay_due_security + delay_due_late_aircraft), 2) AS late_aircraft_pct
FROM flights
WHERE cancelled = 0;

--Q5: Which 3 airlines were the worst in each year 

SELECT year, airline, avg_delay, delay_rank
FROM (
    SELECT
        EXTRACT(YEAR FROM fl_date) AS year,
        airline,
        ROUND(AVG(dep_delay), 2) AS avg_delay,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM fl_date)
            ORDER BY AVG(dep_delay) DESC
        ) AS delay_rank
    FROM flights
    WHERE cancelled = 0
    GROUP BY EXTRACT(YEAR FROM fl_date), airline
) ranked
WHERE delay_rank <= 3
ORDER BY year, delay_rank;

-- Q6: Cancellation Reasons Breakdown

SELECT 
    cancellation_code,
    COUNT(*) AS total_cancellations
FROM flights
WHERE cancelled = 1
GROUP BY cancellation_code
ORDER BY total_cancellations DESC;

-- Q7: Which airlines have the highest cancellation rate ?

SELECT
    airline,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
    ROUND(100.0 * SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate_pct
FROM flights
GROUP BY airline
ORDER BY cancel_rate_pct DESC;

-- Q8: How did flights and cancellations change year by year?

SELECT
    EXTRACT(YEAR FROM fl_date) AS year,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
    ROUND(100.0 * SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate_pct
FROM flights
GROUP BY EXTRACT(YEAR FROM fl_date)
ORDER BY year;

-- Q9: Total flights, cancelled flights, cancellation rate, average departure delay, operated flights

SELECT
    COUNT(*) AS total_flights,
    SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
    ROUND(100.0 * SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate_pct,
    ROUND(AVG(dep_delay) FILTER (WHERE cancelled = 0), 2) AS avg_dep_delay,
	SUM(CASE WHEN cancelled = 0 THEN 1 ELSE 0 END) AS operated_flights
FROM flights;

-- Q10: Cancelled flights by month

SELECT
    EXTRACT(MONTH FROM fl_date) AS month,
    COUNT(*) AS cancelled_flights
FROM flights
WHERE cancelled = 1
GROUP BY EXTRACT(MONTH FROM fl_date)
ORDER BY month;

-- Q11: Which origin airports have the highest average departure delay? (200+ flights)

SELECT
    origin,
    origin_city,
    ROUND(AVG(dep_delay), 2) AS avg_delay,
    COUNT(*) AS total_flights
FROM flights
WHERE cancelled = 0
GROUP BY origin, origin_city
HAVING COUNT(*) > 200
ORDER BY avg_delay DESC
LIMIT 10;

-- Q12: At what time of day are delays highest?

SELECT
    FLOOR(crs_dep_time / 100) AS dep_hour,
    ROUND(AVG(dep_delay), 2) AS avg_delay,
    COUNT(*) AS total_flights
FROM flights
WHERE cancelled = 0
  AND crs_dep_time >= 500
GROUP BY FLOOR(crs_dep_time / 100)
ORDER BY dep_hour;

-- Q13: What percentage of flights arrive on time (arrival delay of 15 minutes or less)?

SELECT
    ROUND(100.0 * SUM(CASE WHEN arr_delay <= 15 THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct
FROM flights
WHERE cancelled = 0 AND diverted = 0;







