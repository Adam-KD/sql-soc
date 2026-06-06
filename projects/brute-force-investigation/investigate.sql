-- Brute Force Investigation
-- Date: 2026-06-06
-- Scenario: Multiple IPs attempting unauthorized access via credential brute force

-- ============================================================
-- STEP 1: Full picture — all failed logins chronologically
-- ============================================================

SELECT * FROM auth_events
WHERE result = 'FAILED'
ORDER BY timestamp ASC;

-- ============================================================
-- STEP 2: Failed attempts per IP — who is most aggressive?
-- ============================================================

SELECT src_ip, COUNT(*) AS total_attempts
FROM auth_events
WHERE result = 'FAILED'
GROUP BY src_ip
ORDER BY total_attempts DESC;

-- ============================================================
-- STEP 3: Threat intel check — are these known bad actors?
-- ============================================================

SELECT DISTINCT auth_events.src_ip, threat_intel.threat_type, 
       threat_intel.confidence, threat_intel.source
FROM auth_events
INNER JOIN threat_intel ON auth_events.src_ip = threat_intel.ip
WHERE auth_events.result = 'FAILED';

-- ============================================================
-- STEP 4: Did any threat intel IP successfully log in?
-- ============================================================

SELECT DISTINCT auth_events.src_ip, auth_events.result
FROM auth_events
INNER JOIN threat_intel ON auth_events.src_ip = threat_intel.ip
WHERE auth_events.result = 'SUCCESS';

-- ============================================================
-- STEP 5: Did ANY attacker get in? (including non-threat-intel IPs)
-- ============================================================

SELECT DISTINCT src_ip, username, timestamp
FROM auth_events
WHERE result = 'SUCCESS' AND src_ip IN (
    SELECT src_ip FROM auth_events
    WHERE result = 'FAILED'
);

-- ============================================================
-- STEP 6: Attack timeline — duration and attempt count per IP
-- ============================================================

SELECT src_ip, 
       MIN(timestamp) AS first_attempt, 
       MAX(timestamp) AS last_attempt, 
       COUNT(*) AS total_attempts
FROM auth_events
WHERE result = 'FAILED'
GROUP BY src_ip
ORDER BY total_attempts DESC;

-- ============================================================
-- STEP 6b: Inspect internal host activity individually
-- Manually reviewing 192.168.1.88 to assess attempt timing
-- and rule out precise interval scheduling
-- ============================================================

SELECT * FROM auth_events
WHERE src_ip = '192.168.1.88'
ORDER BY timestamp ASC;

-- ============================================================
-- STEP 7: Full investigation summary
-- ============================================================

SELECT auth_events.src_ip,
       COUNT(*) AS total_attempts,
       MIN(timestamp) AS first_attempt,
       MAX(timestamp) AS last_attempt,
       CASE WHEN auth_events.src_ip IN (
           SELECT src_ip FROM auth_events WHERE result = 'SUCCESS'
       ) THEN 'YES' ELSE 'NO' END AS breached,
       threat_intel.threat_type,
       threat_intel.confidence,
       threat_intel.source
FROM auth_events
LEFT JOIN threat_intel ON auth_events.src_ip = threat_intel.ip
WHERE auth_events.result = 'FAILED'
GROUP BY auth_events.src_ip
ORDER BY total_attempts DESC;