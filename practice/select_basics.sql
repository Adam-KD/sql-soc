-- SQL Day 1 Practice

-- ============================================================
-- SETUP: Create a table that looks like auth log data
-- ============================================================

CREATE TABLE IF NOT EXISTS auth_events (
    id         INTEGER,
    src_ip     TEXT,
    username   TEXT,
    result     TEXT,
    attempts   INTEGER,
    timestamp  TEXT
);

DELETE FROM auth_events;

INSERT INTO auth_events VALUES
(1, '192.168.1.10', 'alice',   'SUCCESS', 1, '2024-01-15 08:01:00'),
(2, '10.0.0.55',   'root',    'FAILED',  1, '2024-01-15 08:03:22'),
(3, '10.0.0.55',   'root',    'FAILED',  2, '2024-01-15 08:03:45'),
(4, '10.0.0.55',   'root',    'FAILED',  3, '2024-01-15 08:04:01'),
(5, '192.168.1.22','bob',     'SUCCESS', 1, '2024-01-15 09:15:00'),
(6, '45.33.22.11', 'admin',   'FAILED',  1, '2024-01-15 10:00:00'),
(7, '45.33.22.11', 'admin',   'FAILED',  2, '2024-01-15 10:00:12'),
(8, '192.168.1.10','alice',   'SUCCESS', 1, '2024-01-15 11:30:00'),
(9, '172.16.0.5',  'charlie', 'FAILED',  1, '2024-01-15 14:22:00'),
(10,'45.33.22.11', 'admin',   'FAILED',  3, '2024-01-15 14:45:00');


-- ============================================================
-- EXERCISE 1: Get everything — what does the full table look like?
-- ============================================================

SELECT *
FROM auth_events;


-- ============================================================
-- EXERCISE 2: Only show src_ip and result — ignore the other columns
-- ============================================================

SELECT src_ip, result
FROM auth_events;


-- ============================================================
-- EXERCISE 3: Only the FAILED events
-- ============================================================

SELECT *
FROM auth_events
WHERE result = 'FAILED';


-- ============================================================
-- EXERCISE 4: Only the SUCCESS events
-- ============================================================

SELECT *
FROM auth_events
WHERE result = 'SUCCESS';


-- ============================================================
-- EXERCISE 5: Failed attempts from one specific IP
-- The external IP 45.33.22.11 looks suspicious — show its events
-- ============================================================

SELECT *
FROM auth_events
WHERE src_ip = '45.33.22.11';


-- ============================================================
-- EXERCISE 6: Failed events AND more than 1 attempt
-- ============================================================

SELECT *
FROM auth_events
WHERE result = 'FAILED'
  AND attempts > 1;


-- ============================================================
-- CHALLENGE: Find all rows where username is 'root' OR 'admin'
-- These are the accounts attackers brute-force first
-- ============================================================

SELECT *
FROM auth_events
WHERE username = 'root' OR username = 'admin';

