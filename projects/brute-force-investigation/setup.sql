-- Brute Force Investigation — Setup
-- Creates and populates tables for the investigation scenario

-- ============================================================
-- AUTH EVENTS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS auth_events (
    id        INTEGER,
    src_ip    TEXT,
    username  TEXT,
    result    TEXT,
    timestamp TEXT
);

DELETE FROM auth_events;

INSERT INTO auth_events VALUES
(1,  '45.33.22.11', 'admin',    'FAILED',  '2024-03-15 02:01:13'),
(2,  '45.33.22.11', 'admin',    'FAILED',  '2024-03-15 02:01:45'),
(3,  '45.33.22.11', 'admin',    'FAILED',  '2024-03-15 02:02:10'),
(4,  '45.33.22.11', 'admin',    'FAILED',  '2024-03-15 02:02:33'),
(5,  '45.33.22.11', 'admin',    'FAILED',  '2024-03-15 02:02:58'),
(6,  '45.33.22.11', 'admin',    'SUCCESS', '2024-03-15 02:03:21'),
(7,  '91.108.4.55', 'root',     'FAILED',  '2024-03-15 02:15:00'),
(8,  '91.108.4.55', 'root',     'FAILED',  '2024-03-15 02:15:22'),
(9,  '91.108.4.55', 'root',     'FAILED',  '2024-03-15 02:15:44'),
(10, '91.108.4.55', 'admin',    'FAILED',  '2024-03-15 02:16:01'),
(11, '91.108.4.55', 'admin',    'FAILED',  '2024-03-15 02:16:20'),
(12, '91.108.4.55', 'admin',    'FAILED',  '2024-03-15 02:16:45'),
(13, '91.108.4.55', 'admin',    'FAILED',  '2024-03-15 02:17:02'),
(14, '192.168.1.88','alice',    'FAILED',  '2024-03-15 09:11:00'),
(15, '192.168.1.88','alice',    'FAILED',  '2024-03-15 09:11:30'),
(16, '192.168.1.88','alice',    'SUCCESS', '2024-03-15 09:12:01'),
(17, '10.0.0.12',  'bob',      'SUCCESS', '2024-03-15 08:45:00'),
(18, '10.0.0.15',  'charlie',  'SUCCESS', '2024-03-15 08:50:00');

-- ============================================================
-- THREAT INTEL TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS threat_intel (
    ip          TEXT,
    threat_type TEXT,
    confidence  TEXT,
    source      TEXT
);

DELETE FROM threat_intel;

INSERT INTO threat_intel VALUES
('45.33.22.11', 'brute_force', 'HIGH',   'AbuseIPDB'),
('91.108.4.55', 'scanner',     'MEDIUM', 'AlienVault'),
('185.220.101.1','tor_exit',   'HIGH',   'TorProject');