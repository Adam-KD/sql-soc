# Brute Force Investigation: Findings Report

**Analyst:** Adam  
**Incident Date:** March 15, 2024  
**Report Date:** June 6, 2026  
**Severity:** Critical  

**Note:** Simulated investigation based on a sample authentication log 
from a reported incident. Conducted as part of a SOC analyst portfolio project.
IP addresses and usernames have been anonymized for publication.

---

## Summary

On March 15, 2024, three IP addresses were associated with repeated 
failed authentication attempts against internal systems. Two external 
IPs were identified in threat intelligence databases as known malicious 
actors. One of them successfully breached the system via brute force. 
A third internal host also exhibited suspicious login behavior 
approximately 7 hours later, raising concerns of lateral movement 
post-compromise.

---

## Findings

**1. `45.33.22.11` — Confirmed Breach (CRITICAL)**
- 5 failed attempts followed by 1 successful login to `admin` account
- Attack duration: 2 minutes 8 seconds (02:01:13 — 02:03:21)
- Flagged in AbuseIPDB as brute force, HIGH confidence
- Speed and consistency of attempts indicates automated tooling
- Short duration with success suggests a targeted wordlist rather than 
  random guessing - possible prior knowledge via insider information, 
  social engineering, or OSINT
- **Immediate action required**

**2. `91.108.4.55` — Attempted Breach, Unsuccessful (MEDIUM)**
- 7 failed attempts against `root` and `admin` accounts
- Attack duration: 2 minutes 2 seconds (02:15:00 — 02:17:02)
- Flagged in AlienVault as scanner, MEDIUM confidence
- Began approximately 13 minutes after first attacker
- Attempt intervals of 20-30 seconds - consistent with automated 
  tooling but not precisely timed, ruling out strict interval scheduling
- Did not succeed - worth monitoring for follow-up activity
- **Escalate for further investigation**

**3. `192.168.1.88` — Internal Host, Suspicious Activity (MEDIUM)**
- 2 failed attempts followed by 1 successful login to `alice` account
- Activity at 09:11:00 - 09:12:01, approximately 7 hours after breach
- Attempts spaced ~30 seconds apart - unusual for legitimate user
- Internal IP raises two possibilities: compromised host being used 
  for lateral movement post-breach, or an internal threat actor
- 3 total attempts with success on third is borderline normal behavior 
  but timing warrants investigation
- **Identify host behind this IP and investigate account holder**

---

## Timeline

| Time | IP | Event |
|------|----|-------|
| 02:01:13 | 45.33.22.11 | First failed attempt — admin |
| 02:02:58 | 45.33.22.11 | Last failed attempt — admin |
| 02:03:21 | 45.33.22.11 | **Successful login — admin** |
| 02:15:00 | 91.108.4.55 | First failed attempt — root |
| 02:17:02 | 91.108.4.55 | Last failed attempt — admin |
| 09:11:00 | 192.168.1.88 | First failed attempt — alice |
| 09:11:30 | 192.168.1.88 | Second failed attempt — alice |
| 09:12:01 | 192.168.1.88 | **Successful login — alice** |

---

## Indicators of Compromise (IOCs)

| Type | Value | Notes |
|------|-------|-------|
| IP | 45.33.22.11 | External, AbuseIPDB — brute force HIGH |
| IP | 91.108.4.55 | External, AlienVault — scanner MEDIUM |
| IP | 192.168.1.88 | Internal host — suspicious activity |
| Account | admin | Compromised — 45.33.22.11 |
| Account | alice | Compromised — 192.168.1.88 |

---

## Recommendations

1. **Immediately isolate** any session or process spawned by 
   `45.33.22.11` - treat `admin` account as compromised, rotate 
   credentials, audit all activity post 02:03:21
2. **Identify and investigate** the host behind `192.168.1.88` -
   determine if it was compromised as part of lateral movement from 
   the earlier breach
3. **Block** `45.33.22.11` and `91.108.4.55` at the perimeter firewall
4. **Review** `admin` and `alice` account activity for the full day 
   of March 15 for signs of persistence or data exfiltration
5. **Implement account lockout policy** - neither account locked after 
   repeated failures, which enabled the breach
6. **Monitor** `91.108.4.55` - did not succeed but may return

---

## Conclusion

The evidence strongly suggests a coordinated brute force attack against 
privileged accounts. `45.33.22.11` successfully compromised the `admin` 
account. The internal activity 7 hours later is consistent with lateral 
movement and should be treated as related until proven otherwise.