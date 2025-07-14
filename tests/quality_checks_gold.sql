/*
===============================================================================
Validation Script: Gold Layer Quality Checks
===============================================================================
Purpose     :
    This script performs data quality validation on the Gold Layer of the
    data warehouse to ensure:
        - Uniqueness of surrogate keys in dimension tables
        - Referential integrity between fact and dimension tables
        - Proper data model alignment for analytical accuracy

Usage Notes:
    - Run this script after the Gold Layer views have been created
    - Any non-zero results indicate a data quality issue that needs attention
===============================================================================
*/

-- =============================================================================
-- 🔍 Check 1: Uniqueness of customer_key in gold.dim_customers
-- Expectation: No duplicate keys
-- =============================================================================
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- =============================================================================
-- 🔍 Check 2: Uniqueness of product_key in gold.dim_products
-- Expectation: No duplicate keys
-- =============================================================================
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- =============================================================================
-- 🔍 Check 3: Orphan Records in gold.fact_sales
-- Verifies referential integrity to dimension tables
-- Expectation: No records with NULL dimension keys
-- =============================================================================
SELECT 
    f.order_number,
    f.product_key,
    f.customer_key,
    CASE 
        WHEN p.product_key IS NULL THEN 'Missing Product'
        WHEN c.customer_key IS NULL THEN 'Missing Customer'
    END AS issue_type
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products  p ON f.product_key  = p.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
