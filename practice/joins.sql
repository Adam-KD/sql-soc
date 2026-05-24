-- JOIN Practice
-- Concepts: INNER JOIN, LEFT JOIN, NULL filtering, multi-table queries

-- ============================================================
-- SETUP: Create threat intel table
-- ============================================================

CREATE TABLE IF NOT EXISTS threat_intel (
    ip          TEXT,
    threat_type TEXT,
    confidence  TEXT
);

DELETE FROM threat_intel;

INSERT INTO threat_intel VALUES
('45.33.22.11', 'brute_force', 'HIGH'),
('10.0.0.55',   'scanner',     'MEDIUM'),
('1.2.3.4',     'malware_c2',  'HIGH');

-- ============================================================
-- WARMUP: Check both tables
-- ============================================================

SELECT * FROM auth_events;

SELECT * FROM threat_intel;

-- ============================================================
-- EXERCISE 1: INNER JOIN — only IPs that exist in both tables
-- ============================================================

SELECT auth_events.src_ip, auth_events.username, auth_events.result,
       threat_intel.threat_type, threat_intel.confidence
FROM auth_events
INNER JOIN threat_intel ON auth_events.src_ip = threat_intel.ip;

-- ============================================================
-- EXERCISE 2: LEFT JOIN — all events, flag known threats
-- ============================================================

SELECT auth_events.src_ip, auth_events.username, auth_events.result,
       threat_intel.threat_type, threat_intel.confidence
FROM auth_events
LEFT JOIN threat_intel ON auth_events.src_ip = threat_intel.ip;

-- ============================================================
-- EXERCISE 3: Find IPs with no threat intel match
-- ============================================================

SELECT auth_events.src_ip, auth_events.username, auth_events.result,
       threat_intel.threat_type, threat_intel.confidence
FROM auth_events
LEFT JOIN threat_intel ON auth_events.src_ip = threat_intel.ip
WHERE threat_intel.threat_type IS NULL;

-- ============================================================
-- CHALLENGE: Failed events only, enriched with threat intel
-- ============================================================

SELECT auth_events.src_ip, auth_events.username, auth_events.result,
       threat_intel.threat_type, threat_intel.confidence
FROM auth_events
LEFT JOIN threat_intel ON auth_events.src_ip = threat_intel.ip
WHERE auth_events.result = 'FAILED'
ORDER BY confidence ASC;