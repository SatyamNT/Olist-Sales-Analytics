# Olist E-Commerce Sales Analytics

An end-to-end analysis of 96K real delivered orders from the Olist Brazilian marketplace (Jan 2017 - Aug 2018), with an interactive dashboard.

**Live dashboard:** see the GitHub Pages link in this repository's About section.

## Business question
Where is revenue coming from, and where are late deliveries hurting customers?

## Key findings
- Revenue: R$13.2M across 96,203 delivered orders; average order value R$137.
- Growth: Jan-Aug 2018 revenue up 141% vs Jan-Aug 2017 (R$7.22M vs R$2.99M).
- Concentration: Sao Paulo gives 38.4% of revenue; SP, RJ and MG together about 63%.
- Top categories: health_beauty (9.3%), watches_gifts (8.8%), bed_bath_table (7.8%).
- Delivery risk: 8.1% of orders arrive late; late orders average 2.57 stars vs 4.30 on time.

## Recommendations
1. Plan inventory and marketing around November, the peak month.
2. Grow RJ and MG to reduce dependence on one state.
3. Fix delivery estimates and carriers in states with the highest late rates.

## Method
1. Loaded 6 Olist tables into SQLite and joined them (see `sql/olist_analysis.sql`).
2. Cleaned: delivered orders only, removed 8 delivered orders with no delivery date, dropped 2016 and late-2018 months (too sparse), translated category names, revenue = item price excluding freight.
3. Computed KPIs, aggregated by month, state and category, and built the dashboard (JavaScript, Chart.js).

## Limitations
- 20 months of data, so seasonality cannot be fully separated from growth.
- Orders with several categories count once in each category.
- Low reviews are linked to late delivery, not proven to be caused by it.

## Data
Brazilian E-Commerce Public Dataset by Olist: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

## Files
- `index.html` - interactive dashboard (data embedded)
- `sql/olist_analysis.sql` - all SQL queries

Built by Satyam Nath Tiwari.
