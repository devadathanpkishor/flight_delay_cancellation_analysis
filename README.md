# Airline Delay & Cancellation Analysis (SQL + Power BI)

An end-to-end data analytics project that analyses 100,000 US domestic flights (January 2019 to August 2023) to find out **which airlines, routes and months suffer most from delays and cancellations, and why**.

## Business questions

1. Which airlines and routes have the highest departure delays?
2. How do delays change across months and years?
3. What causes delays (carrier, late aircraft, weather, NAS, security)?
4. Which airlines cancel the most flights, in absolute numbers and as a rate?
5. How did cancellations change from 2019 to 2023?

## Tools

| Step | Tool |
|---|---|
| Data storage and analysis | PostgreSQL (window functions, `CASE WHEN`, `FILTER`, aggregation) |
| Exploration and cross-check | Python (pandas, matplotlib) in Google Colab |
| Dashboard | Power BI (DAX measures, slicers, KPI cards) |

## Project workflow

Raw CSV → PostgreSQL table → data quality checks → SQL analysis (13 queries) → Python exploration (pandas, matplotlib) → Power BI dashboard (3 pages) → insights

## Dataset

- File: `flights_sample_100k.csv` (100,000 rows, 32 columns)
- Period: 2019-01-01 to 2023-08-31
- Operated flights: 97,373 | Cancelled flights: 2,627
- Source: Kaggle

## Query to dashboard mapping

| Query | Business question | Dashboard visual |
|---|---|---|
| Q1 | Average departure delay by airline | Average Departure Delay by Airline (bar) |
| Q2 | Top 10 most delayed routes (20+ flights) | Top Routes by Departure Delay (table) |
| Q3 | Average delay by month | Average Departure Delay by Month (line) with Year slicer |
| Q4 | Share of delay minutes by cause | Delay Contribution by Cause (donut) |
| Q5 | Three worst airlines in each year (`RANK() OVER PARTITION BY`) | SQL analysis, explored with the Year slicer on the airline chart |
| Q6 | Cancellations by reason code | Cancellation Code Chart (column) |
| Q7 | Cancellation rate by airline | Cancellation Rate % by Airline (bar) |
| Q8 | Flights and cancellation rate by year | Cancellation Rate % by Year (column) |
| Q9 | Total flights, cancelled flights, cancellation rate, average delay | KPI cards |
| Q10 | Cancelled flights by month | Cancelled Flights by Month (line) |
| Q11 | Airports with the highest average departure delay (200+ flights) | Airports by Departure Delay (table) |
| Q12 | Average delay by scheduled departure hour (5 AM onwards) | Average Departure Delay by Hour of Day (line) |
| Q13 | Share of flights arriving within 15 minutes of schedule | On-Time % card |


## Key findings

- **Overall:** 2.63% of flights were cancelled. Operated flights departed 10.1 minutes late on average.
- **Airline delays:** JetBlue has the highest average departure delay (19.9 min), followed by Allegiant (16.3) and ExpressJet (15.7).
- **Causes:** Carrier issues (37.1%) and late-arriving aircraft (37.0%) together account for about 74% of delay minutes. Weather accounts for only 5.8%.
- **Worst route:** Fort Lauderdale to Orlando (FLL to MCO) averages 93 minutes of departure delay (24 flights).
- **Cancellations peaked in 2020:** 6.1% of flights were cancelled, compared with 1.6% to 2.8% in the other years. March and April 2020 alone account for 842 cancelled flights.
- **Delays build through the day:** average departure delay rises from about 3.6 minutes for 6 AM departures to about 17 minutes in the evening. A possible reason is that early delays carry over to later flights (late-arriving aircraft are 37% of delay minutes), but the data does not prove this.
- **Airports:** Grand Rapids (22.5 min), San Juan (19.7) and Fort Lauderdale (17.4) have the highest average departure delay among airports with 200+ flights.
- **On-time performance:** 82.1% of flights arrive within 15 minutes of schedule.
- **Python check:** flight distance has only a very weak relationship with delay (correlation 0.018). The median departure is 2 minutes early, while the 10.1-minute average is pulled up by a minority of long delays (about 6% of flights are delayed over an hour).
- **Count vs rate:** Southwest has the most cancelled flights (654) but a rate of 3.4%, because it also has the most flights. Allegiant (4.5%) and ExpressJet (4.5%) have the highest rates.

## Notes and limitations

- **Cancellation code D ("Security"):** 818 of the 827 flights with this code are in 2020. It is unusually high for a security reason and may reflect how pandemic-era cancellations were recorded. This is not verified.
- **Delay cause columns** are only filled for flights delayed by 15 minutes or more, so the cause breakdown describes delayed flights only.
- **Sample data:** This is a 100K sample, so airlines with few flights (for example ExpressJet with 649 flights) have less stable rates.
- **Q3** pools all years by month. The dashboard adds a Year slicer for year-level views.

## Recommendations

- Because carrier issues and late-arriving aircraft cause about 74% of delay minutes, airlines would gain most from improving aircraft turnaround and schedule buffers, not from weather planning.
- Cancellation monitoring should use rates, not counts, so that large airlines are not unfairly flagged.
- Planning for the summer peak (June) in staffing and spare aircraft could reduce delays.


## Author

Devadathan P K
