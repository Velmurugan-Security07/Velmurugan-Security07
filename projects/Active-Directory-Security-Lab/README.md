# Active Directory Security Lab

A home lab that builds a Windows Active Directory domain (`lab.local`), applies baseline security settings, and uses the resulting logs to practise **SOC detections**.

## What this project shows
| Skill | Where |
|---|---|
| Active Directory Domain Services install (new forest) | `scripts/01-install-adds.ps1` |
| OU, user and group design | `02`, `03` scripts + `users.csv` |
| Password and account-lockout policy | `04-password-policy-and-gpo.ps1` |
| Group Policy (screen lock, block USB) | `04-password-policy-and-gpo.ps1` |
| Security auditing configuration | `05-enable-auditing.ps1` |
| Detection engineering: Event IDs and Splunk searches | `detections/` |

## Lab setup
| Machine | OS | Role |
|---|---|---|
| DC01 | Windows Server 2022 (evaluation) | Domain Controller + DNS |
| WS01 | Windows 10/11 | Domain-joined workstation |
| (optional) SIEM | Splunk Free / Security Onion | Receives Windows logs |

Run everything in VirtualBox/VMware on an **isolated host-only network**. All names and users are fictional.

## Steps
1. Install Windows Server on DC01, set a static IP, rename to `DC01`.
2. Run `01-install-adds.ps1` (server reboots).
3. Run `02`, then `03`, `04`, `05` in order (PowerShell as Administrator).
4. Join WS01 to `lab.local` and sign in as a lab user.
5. Generate the test events below and look at them in Event Viewer (or Splunk).

## Detection tests (safe, in your own lab)
| # | Do this | Event to find | Detection |
|---|---|---|---|
| 1 | Type a wrong password 6 times for one user on WS01 | 4625 ×6, then 4740 | Brute-force / lockout search |
| 2 | Create a new user in ADUC | 4720 | New-account search |
| 3 | Add that user to a privileged group | 4728 / 4732 | Privileged-group search |
| 4 | Clear the Security log (lab only) | 1102 | Log-cleared search |

For each test, save a screenshot in `docs/images/` and add a short write-up: *what happened → which event → how I detected it → how I would respond*.

## Evidence checklist
- [ ] `docs/images/01-domain-created.png` — `Get-ADDomain` output
- [ ] `docs/images/02-ou-structure.png` — ADUC tree
- [ ] `docs/images/03-gpo-linked.png` — Group Policy Management
- [ ] `docs/images/04-4625-events.png` — failed logons
- [ ] `docs/images/05-4728-group-change.png` — group-membership change
- [ ] `docs/images/06-splunk-alert.png` — search result (if SIEM used)

## Next steps
- Forward logs to Splunk/Security Onion and turn the searches into alerts
- Add Sysmon for process-level visibility
- Map each detection to a MITRE ATT&CK technique

## Related certificates
Tata/Forage IAM job simulation and Google Cybersecurity Certificate — see my [profile](https://github.com/Velmurugan-Security07).

## Author
**Velmurugan A.** · [GitHub](https://github.com/Velmurugan-Security07) · [LinkedIn](https://www.linkedin.com/in/velmurugan-anand)
