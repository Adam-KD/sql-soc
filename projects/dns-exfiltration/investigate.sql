-- DNS Exfiltration Investigation
-- Date: 2026-06-09
-- Scenario: Suspected DNS-based data exfiltration from internal host
-- Data source: DNS query logs collected via Zeek and ingested into SIEM

-- ============================================================
-- STEP 1: Full picture - all DNS queries chronologically
-- ============================================================

SELECT * FROM dns_logs
ORDER BY timestamp ASC;

-- ============================================================
-- STEP 2: Query volume per host - who is most active?
-- ============================================================

SELECT src_ip, COUNT(*) AS total_queries
FROM dns_logs
GROUP BY src_ip
ORDER BY total_queries DESC;

-- ============================================================
-- STEP 3: Activity window per host - when and how long?
-- ============================================================

SELECT src_ip,
       COUNT(*) AS total_queries,
       MIN(timestamp) AS first_seen,
       MAX(timestamp) AS last_seen,
       ROUND((JULIANDAY(MAX(timestamp)) - JULIANDAY(MIN(timestamp))) * 86400 / 60) AS duration_minutes
FROM dns_logs
GROUP BY src_ip
ORDER BY total_queries DESC;

-- ============================================================
-- STEP 4: Inspect suspected host individually
-- 192.168.1.105 flagged for anomalous volume - review all its queries
-- ============================================================

SELECT * FROM dns_logs
WHERE src_ip = '192.168.1.105'
ORDER BY timestamp ASC;

-- ============================================================
-- STEP 5: TXT query check - which hosts are making TXT requests?
-- TXT queries from workstations are rare and suspicious
-- ============================================================

SELECT src_ip, COUNT(*) AS txt_queries
FROM dns_logs
WHERE query_type = 'TXT'
GROUP BY src_ip;

-- ============================================================
-- STEP 6: Distinct queries from suspected host
-- Reviewing encoded subdomains for exfiltration indicators
-- ============================================================

SELECT DISTINCT query
FROM dns_logs
WHERE src_ip = '192.168.1.105';

-- ============================================================
-- STEP 7: Domain extraction - isolate parent domains
-- Identifies unknown/suspicious domains across all traffic
-- ============================================================

SELECT DISTINCT SUBSTR(query, INSTR(query, '.') + 1) AS domain
FROM dns_logs;

-- ============================================================
-- STEP 8: Average response size per host
-- Large responses from 192.168.1.105 suggest C2 communication
-- ============================================================

SELECT src_ip, ROUND(AVG(response_size)) AS avg_response_size
FROM dns_logs
GROUP BY src_ip
ORDER BY avg_response_size DESC;

-- ============================================================
-- STEP 9: Beaconing detection - time intervals between queries
-- Consistent 30s intervals confirm automated tooling
-- ============================================================

SELECT src_ip,
       query,
       ROUND((JULIANDAY(timestamp) - JULIANDAY(LAG(timestamp) 
           OVER (PARTITION BY src_ip ORDER BY timestamp))) * 86400) AS seconds_since_last
FROM dns_logs
WHERE src_ip = '192.168.1.105'
ORDER BY timestamp ASC;

-- ============================================================
-- STEP 10: Full investigation summary
-- ============================================================

SELECT src_ip,
       COUNT(*) AS total_queries,
       ROUND(AVG(response_size)) AS avg_response_size,
       ROUND(AVG(LENGTH(query))) AS avg_query_length,
       SUM(CASE WHEN query_type = 'TXT' THEN 1 ELSE 0 END) AS txt_queries,
       SUM(CASE WHEN SUBSTR(query, INSTR(query, '.') + 1) = 'exfil-c2.net' 
           THEN 1 ELSE 0 END) AS queries_to_suspected_domain,
       CASE WHEN SUM(CASE WHEN SUBSTR(query, INSTR(query, '.') + 1) = 'exfil-c2.net' 
           THEN 1 ELSE 0 END) > 0 
           THEN 'MALICIOUS' ELSE 'CLEAN' END AS verdict
FROM dns_logs
GROUP BY src_ip
ORDER BY queries_to_suspected_domain DESC;