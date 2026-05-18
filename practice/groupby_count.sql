-- GROUP BY + COUNT() Practice
-- Concepts: GROUP BY, COUNT(*), ORDER BY, WHERE + GROUP BY

-- ============================================================
-- WARMUP: Check the data
-- ============================================================

SELECT * FROM auth_events;

-- ============================================================
-- EXERCISE 1: How many events per IP?
-- ============================================================

SELECT src_ip, COUNT(*) AS total_attempts
FROM auth_events
GROUP BY src_ip;

-- ============================================================
-- EXERCISE 2: How many failed attempts per username?
-- ============================================================

SELECT username, COUNT(*) AS total_attempts
FROM auth_events
WHERE result = 'FAILED'
GROUP BY username;

-- ============================================================
-- EXERCISE 3: Brute force detection — failed attempts per IP, worst first
-- ============================================================

SELECT src_ip, COUNT(*) AS total_attempts
FROM auth_events
WHERE result = 'FAILED'
GROUP BY src_ip
ORDER BY total_attempts DESC;