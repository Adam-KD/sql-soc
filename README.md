# sql-soc

Learning SQL through hands-on SOC analysis - notes, structured practice, 
and investigative projects built around real attack scenarios.

## Projects

### Brute Force Investigation
Simulated investigation of a credential brute force attack against 
internal systems. Uses authentication logs and threat intelligence data 
to identify attackers, confirm breaches, and assess lateral movement.

- Multi-table queries with JOIN and subqueries
- Threat intel enrichment via cross-referencing
- Full findings report with IOCs and recommendations

[`Brute Force`](https://github.com/Adam-KD/sql-soc/tree/main/projects/brute-force-investigation)

### DNS Exfiltration Investigation
Simulated investigation of DNS-based data exfiltration from a compromised
internal host. Uses Zeek-style DNS query logs to detect encoded subdomains,
beaconing intervals, and C2 communication patterns.

- Behavioral detection without simple pass/fail indicators
- Window functions (LAG) for beaconing interval analysis
- String parsing with SUBSTR and INSTR for domain extraction
- Full findings report with IOCs, recommendations, and detection limitations

[`DNS Exfiltration`](https://github.com/Adam-KD/sql-soc/tree/main/projects/dns-exfilteration)

## Skills Covered

`SELECT` `WHERE` `GROUP BY` `COUNT` `ORDER BY` `LIMIT` `DISTINCT`
`INNER JOIN` `LEFT JOIN` `Subqueries` `CASE WHEN` `Aggregate Functions`
`Window Functions` `LAG` `SUBSTR` `INSTR` `LENGTH`

## Part of a broader SOC portfolio

- [`soc-simulations`](https://github.com/Adam-KD/soc-simulations) - 
  attack simulations documented in a controlled virtual lab
- [`python-soc`](https://github.com/Adam-KD/python-soc) - 
  Python automation tools for SOC workflows
