# DNS Exfiltration Investigation: Findings Report

**Analyst:** Adam  
**Incident Date:** June 10, 2024  
**Report Date:** June 6, 2026  
**Severity:** Critical  

**Note:** Simulated investigation based on DNS query logs from a 
reported incident. Conducted as part of a SOC analyst portfolio project.
Data source: DNS query logs collected via Zeek and ingested into SIEM.
Attacker domain and IP addresses have been anonymized for publication.

---

## Summary

On June 10, 2024, internal host `192.168.1.105` was identified generating 
anomalous DNS traffic over an 11 minute window. Investigation revealed 
19 TXT queries directed at an unknown external domain with base64-encoded 
subdomains, consistent 30-second beaconing intervals, and elevated response 
sizes suggesting bidirectional C2 communication. All indicators point to 
DNS-based data exfiltration via automated tooling. The host is either 
compromised or operated by a malicious insider, raising concerns of a 
prior successful intrusion.

---

## Findings

**1. `192.168.1.105` - Anomalous Query Volume (CRITICAL)**
- 19 DNS queries in 11 minutes vs 1-4 queries from all other hosts
- High volume alone could indicate heavy internet usage, but combined 
  with other indicators confirms malicious intent
- All 19 queries were TXT type - no other host made a single TXT query
- TXT queries from workstations have no legitimate business justification

**2. Encoded Subdomains - Data Exfiltration Indicator**
- 13 distinct subdomains observed, all appearing base64-encoded
- Example: `dGhpcyBpcyBz.exfil-c2.net`, `aGVsbG8gd29y.exfil-c2.net`
- All queries destined to single unknown domain: `exfil-c2.net`
- Average query length of 25 characters vs 10-11 for clean hosts
- Subdomain length directly correlates to volume of exfiltrated data 
  per query

**3. Beaconing - Automated Tooling Confirmed**
- Queries spaced at almost exactly 30 seconds apart consistently
- One gap of 120 seconds observed - likely a brief pause or retry interval
- Precise timing rules out human behavior, confirms automated exfil tool
- Total exfil window: 08:05:00 to 08:16:30

**4. Elevated Response Size - Bidirectional C2 Communication**
- Average response size of 211 bytes vs 45-50 bytes for clean hosts
- Suggests the C2 server at `exfil-c2.net` is sending data back
- Indicates a two-way channel - malware both exfiltrating data and 
  receiving instructions

---

## Timeline

| Time | Event |
|------|-------|
| 08:00:01 | Normal DNS activity begins from clean hosts |
| 08:05:00 | 192.168.1.105 begins TXT queries to exfil-c2.net |
| 08:05:00 - 08:16:30 | 19 TXT queries at 30s intervals |
| 08:12:30 | Brief 120s pause in exfil activity |
| 08:16:30 | Last recorded exfil query |

---

## Indicators of Compromise (IOCs)

| Type | Value | Notes |
|------|-------|-------|
| IP | 192.168.1.105 | Internal host - confirmed malicious activity |
| Domain | exfil-c2.net | Attacker-controlled C2 domain |
| Query type | TXT | Used exclusively for exfil traffic |
| Pattern | Base64 subdomains | Encoded exfiltrated data |
| Interval | 30 seconds | Beaconing signature |

---

## Recommendations

1. **Immediately isolate** `192.168.1.105` from the network - prevent 
   further exfiltration and C2 communication
2. **Block** `exfil-c2.net` and all its subdomains at the DNS resolver 
   and perimeter firewall
3. **Forensic imaging** of `192.168.1.105` - identify the malware, 
   determine what data was exfiltrated, and establish initial compromise 
   vector
4. **Review authentication logs** for `192.168.1.105` - check for signs 
   of prior compromise or unauthorized access, cross-reference with 
   brute force investigation if applicable
5. **Audit all data accessible** from `192.168.1.105` - assess the 
   potential scope of exfiltrated data based on the host's access 
   permissions
6. **Implement DNS monitoring rules** - alert on bulk TXT queries from 
   workstations, long subdomains, and queries to newly registered domains
7. **Consider DNS over HTTPS (DoH) controls** - if attackers upgrade to 
   DoH-based exfil, standard DNS monitoring becomes blind to the traffic

---

## Detection Limitations

This investigation relied on subdomain-based exfiltration detection. 
The following attack variants would not be caught by these queries:

- Beaconing-only C2 with no subdomain data (heartbeat traffic)
- DGA-based C2 where domains are randomly generated daily
- DNS over HTTPS (DoH) exfiltration bypassing standard DNS logging

---

## Conclusion

The evidence confirms DNS-based data exfiltration from internal host 
`192.168.1.105` to attacker-controlled domain `exfil-c2.net`. Automated 
tooling ran for 11 minutes with consistent 30-second beaconing. The 
elevated response sizes indicate active C2 communication, not solely 
outbound exfiltration. Whether this is an insider threat or a compromised 
machine, immediate isolation and forensic investigation are required. 
The possibility of a prior successful intrusion should be treated as 
likely until ruled out.