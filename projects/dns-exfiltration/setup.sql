-- DNS Exfiltration Investigation — Setup
-- Attack: Compromised host exfiltrating data via encoded DNS queries
-- Attacker domain: exfil-c2.net
-- Victim host: 192.168.1.105

CREATE TABLE IF NOT EXISTS dns_logs (
    id            INTEGER,
    timestamp     TEXT,
    src_ip        TEXT,
    query         TEXT,
    query_type    TEXT,
    response_code TEXT,
    response_size INTEGER
);

DELETE FROM dns_logs;

INSERT INTO dns_logs VALUES
-- Normal traffic baseline
(1,  '2024-06-10 08:00:01', '192.168.1.10',  'google.com',              'A',   'NOERROR',  48),
(2,  '2024-06-10 08:00:04', '192.168.1.20',  'microsoft.com',           'A',   'NOERROR',  52),
(3,  '2024-06-10 08:00:07', '192.168.1.30',  'github.com',              'A',   'NOERROR',  44),
(4,  '2024-06-10 08:01:00', '192.168.1.10',  'outlook.com',             'MX',  'NOERROR',  60),
(5,  '2024-06-10 08:01:30', '192.168.1.20',  'slack.com',               'A',   'NOERROR',  45),
(6,  '2024-06-10 08:02:00', '192.168.1.30',  'zoom.us',                 'A',   'NOERROR',  43),

-- Exfiltration traffic from compromised host 192.168.1.105
(7,  '2024-06-10 08:05:00', '192.168.1.105', 'dGhpcyBpcyBz.exfil-c2.net',   'TXT', 'NOERROR',  212),
(8,  '2024-06-10 08:05:30', '192.168.1.105', 'dGhpcyBpcyBz.exfil-c2.net',   'TXT', 'NOERROR',  214),
(9,  '2024-06-10 08:06:00', '192.168.1.105', 'dGVzdGluZyBz.exfil-c2.net',   'TXT', 'NOERROR',  208),
(10, '2024-06-10 08:06:30', '192.168.1.105', 'dGVzdGluZyBz.exfil-c2.net',   'TXT', 'NOERROR',  210),
(11, '2024-06-10 08:07:00', '192.168.1.105', 'c29tZSBkYXRh.exfil-c2.net',   'TXT', 'NOERROR',  215),
(12, '2024-06-10 08:07:30', '192.168.1.105', 'c29tZSBkYXRh.exfil-c2.net',   'TXT', 'NOERROR',  209),
(13, '2024-06-10 08:08:00', '192.168.1.105', 'aGVsbG8gd29y.exfil-c2.net',   'TXT', 'NOERROR',  211),
(14, '2024-06-10 08:08:30', '192.168.1.105', 'aGVsbG8gd29y.exfil-c2.net',   'TXT', 'NOERROR',  213),
(15, '2024-06-10 08:09:00', '192.168.1.105', 'bGQgZXhhbXBs.exfil-c2.net',   'TXT', 'NOERROR',  207),
(16, '2024-06-10 08:09:30', '192.168.1.105', 'bGQgZXhhbXBs.exfil-c2.net',   'TXT', 'NOERROR',  216),
(17, '2024-06-10 08:10:00', '192.168.1.105', 'ZSBkYXRhIGhl.exfil-c2.net',   'TXT', 'NOERROR',  210),
(18, '2024-06-10 08:10:30', '192.168.1.105', 'ZSBkYXRhIGhl.exfil-c2.net',   'TXT', 'NOERROR',  212),

-- Normal traffic continuing from other hosts
(19, '2024-06-10 08:11:00', '192.168.1.10',  'amazon.com',              'A',   'NOERROR',  46),
(20, '2024-06-10 08:11:30', '192.168.1.20',  'dropbox.com',             'A',   'NOERROR',  44),
(21, '2024-06-10 08:12:00', '192.168.1.30',  'office365.com',           'A',   'NOERROR',  50),

-- More exfil from compromised host
(22, '2024-06-10 08:12:30', '192.168.1.105', 'cmUgc29tZSBt.exfil-c2.net',   'TXT', 'NOERROR',  208),
(23, '2024-06-10 08:13:00', '192.168.1.105', 'b3JlIGVuY29k.exfil-c2.net',   'TXT', 'NOERROR',  214),
(24, '2024-06-10 08:13:30', '192.168.1.105', 'ZWQgZGF0YSBz.exfil-c2.net',   'TXT', 'NOERROR',  211),
(25, '2024-06-10 08:14:00', '192.168.1.105', 'dGVhbGluZyBm.exfil-c2.net',   'TXT', 'NOERROR',  209),
(26, '2024-06-10 08:14:30', '192.168.1.105', 'cm9tIHRoZSBu.exfil-c2.net',   'TXT', 'NOERROR',  213),
(27, '2024-06-10 08:15:00', '192.168.1.105', 'ZXR3b3Jr.exfil-c2.net',       'TXT', 'NOERROR',  206),

-- One more normal host for noise
(28, '2024-06-10 08:15:30', '192.168.1.40',  'cloudflare.com',          'A',   'NOERROR',  47),
(29, '2024-06-10 08:16:00', '192.168.1.10',  'twitter.com',             'A',   'NOERROR',  45),
(30, '2024-06-10 08:16:30', '192.168.1.105', 'cGF5bG9hZA.exfil-c2.net',     'TXT', 'NOERROR',  210);