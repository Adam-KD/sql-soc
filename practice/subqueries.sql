-- Subqueries Practice
-- Concepts: scalar subqueries, IN with subqueries, filtering across tables

-- ============================================================
-- EXERCISE 1: Find rows with the maximum attempt number
-- Without subquery (manual two steps)
-- ============================================================

SELECT MAX(attempts) FROM auth_events;

SELECT * FROM auth_events WHERE attempts = 3;

-- With subquery (one step)
SELECT * FROM auth_events
WHERE attempts = (SELECT MAX(attempts) FROM auth_events);

-- ============================================================
-- EXERCISE 2: Find IPs with more than 2 failed attempts
-- Inner query only
-- ============================================================

SELECT src_ip FROM auth_events
WHERE result = 'FAILED'
GROUP BY src_ip
HAVING COUNT(*) > 2;

-- ============================================================
-- EXERCISE 3: Show all events from high-frequency attackers
-- ============================================================

SELECT * FROM auth_events
WHERE src_ip IN (
    SELECT src_ip FROM auth_events
    WHERE result = 'FAILED'
    GROUP BY src_ip
    HAVING COUNT(*) > 2
);

-- ============================================================
-- EXERCISE 4: Show threat intel for high-frequency attackers
-- ============================================================

SELECT * FROM threat_intel
WHERE ip IN (
    SELECT src_ip FROM auth_events
    WHERE result = 'FAILED'
    GROUP BY src_ip
    HAVING COUNT(*) > 2
);

-- ============================================================
-- EXERCISE 5: Show threat intel for any IP in auth_events
-- ============================================================

SELECT * FROM threat_intel
WHERE ip IN (SELECT src_ip FROM auth_events);