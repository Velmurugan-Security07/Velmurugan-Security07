# Home SIEM Lab (Splunk)

A small home SOC: Windows and Linux logs are sent to **Splunk**, and five detection searches turn raw events into alerts that I investigate and document.

## Architecture
```
 DC01 (Windows Server, AD lab) ─┐
 WS01 (Windows client)         ─┼──► Splunk Universal Forwarder ──► Splunk server (Ubuntu) ──► Searches · Alerts · Dashboard
 Linux VM (SSH target)         ─┘          port 9997                    indexes: wineventlog, linux
```
It reuses the machines from my [Active Directory Security Lab](../Active-Directory-Security-Lab).

## What this project shows
| Skill | Where |
|---|---|
| Deploying a SIEM (Splunk) and creating indexes | Setup below |
| Log onboarding (Windows forwarder, Linux file monitor) | `config/` |
| Writing detections in SPL | `detections/detections.spl` |
| Mapping detections to MITRE ATT&CK | `detections/mitre-mapping.md` |
| Incident documentation | `docs/incident-report-template.md` |

## Setup
**1. Splunk server (Ubuntu 22.04 VM, 4 GB RAM+)**
```bash
# download the Splunk Enterprise .deb from splunk.com (free trial / free license), then:
sudo dpkg -i splunk-*.deb
sudo /opt/splunk/bin/splunk start --accept-license
sudo /opt/splunk/bin/splunk enable boot-start
sudo /opt/splunk/bin/splunk enable listen 9997      # receive from forwarders
```
Open `http://<server-ip>:8000` → Settings → Indexes → create **wineventlog** and **linux**.
Copy `config/splunk-server-inputs.conf` to `/opt/splunk/etc/system/local/inputs.conf`, then restart Splunk.

**2. Windows machines**
Install the Splunk **Universal Forwarder** on DC01 (and WS01). Copy `windows-forwarder-inputs.conf` and `windows-forwarder-outputs.conf` (edit the IP) into the forwarder's `etc\\system\\local\\` folder and restart the SplunkForwarder service.
Make sure auditing is on (`05-enable-auditing.ps1` in the AD lab).

**3. Verify data is arriving**
```
index=wineventlog | stats count by EventCode
index=linux | stats count by host
```

## Detection test plan (safe, in your own lab)
| # | Action | Expect | Detection |
|---|---|---|---|
| 1 | Enter a wrong password 6× on WS01 | 4625 ×6 then 4740 | D1, D2 |
| 2 | Add a test user to a privileged group in AD | 4728 / 4732 | D3 |
| 3 | Clear the Security log on WS01 (lab only) | 1102 | D4 |
| 4 | From another VM run `ssh wronguser@<linux-ip>` 6× with bad passwords | "Failed password" lines | D5 |

For each test: save a screenshot in `docs/images/`, then write a one-page report with the template in `docs/`.

## Evidence checklist
- [ ] `docs/images/01-splunk-home.png`
- [ ] `docs/images/02-data-arriving.png`
- [ ] `docs/images/03-D1-bruteforce.png`
- [ ] `docs/images/04-D3-group-change.png`
- [ ] `docs/images/05-D5-ssh-bruteforce.png`
- [ ] 2+ completed incident reports

## Next steps
- Save D1–D5 as scheduled alerts and build a one-page dashboard
- Add Sysmon on Windows for process-level logs
- Try Security Onion alongside Splunk

## Author
**Velmurugan A.** · [GitHub](https://github.com/Velmurugan-Security07) · [LinkedIn](https://www.linkedin.com/in/velmurugan-anand)
