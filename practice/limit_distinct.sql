-- LIMIT + DISTINCT Practice
-- Concepts: LIMIT, DISTINCT

-- ============================================================
-- EXERCISE 1: Top 3 IPs with most failed attempts
-- ============================================================

SELECT src_ip, COUNT(*) AS total_attempts
FROM auth_events
WHERE result = 'FAILED'
GROUP BY src_ip
ORDER BY total_attempts DESC
LIMIT 3;

-- ============================================================
-- EXERCISE 2: Most targeted usernames, failed attempts only
-- ============================================================

SELECT username, COUNT(*) AS total_attempts
FROM auth_events
WHERE result = 'FAILED'
GROUP BY username
ORDER BY total_attempts DESC;

-- ============================================================
-- EXERCISE 3: Unique usernames in the table
-- ============================================================

SELECT DISTINCT username
FROM auth_events;

-- ============================================================
-- EXERCISE 4: Unique results that exist in the table
-- ============================================================

SELECT DISTINCT result
FROM auth_events;