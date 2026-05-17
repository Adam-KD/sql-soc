SELECT * FROM auth_events;

SELECT src_ip, COUNT(*) AS total_attempts
FROM auth_events
GROUP BY src_ip;

SELECT username, COUNT(*) AS total_attempts
FROM auth_events WHERE result = 'FAILED'
GROUP BY username

SELECT src_ip, COUNT(*) AS total_attempts
FROM auth_events WHERE result = 'FAILED'
GROUP BY src_ip ORDER BY total_attempts DESC