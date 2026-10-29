# Windows Event IDs used in this lab

| Event ID | Meaning | Why a SOC analyst cares |
|---|---|---|
| 4624 | Successful logon | Baseline; look for odd hours, odd sources, logon type 10 (RDP) |
| 4625 | Failed logon | Many in a short time = brute force / password spraying |
| 4672 | Special privileges assigned | Admin-level logon |
| 4720 | User account created | Unexpected new accounts = persistence |
| 4722 | User account enabled | Re-enabled dormant account |
| 4724 | Password reset attempt | Account takeover step |
| 4728 / 4732 / 4756 | Member added to security group | Added to Domain Admins / Administrators = privilege escalation |
| 4740 | Account locked out | Often the first sign of password guessing |
| 4768 | Kerberos TGT requested | Authentication baseline |
| 4769 | Kerberos service ticket requested | Unusual volume can indicate Kerberoasting |
| 5136 | Directory object modified | Changes to AD objects/permissions |
| 1102 | Audit log cleared | Attackers hiding tracks — always investigate |
