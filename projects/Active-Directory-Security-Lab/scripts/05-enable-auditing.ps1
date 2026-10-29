# Turns on the audit categories the detections rely on. Run on the domain controller.
$subs = @(
  "Logon","Logoff","Account Lockout","Special Logon",
  "User Account Management","Security Group Management",
  "Kerberos Authentication Service","Kerberos Service Ticket Operations",
  "Directory Service Changes","Audit Policy Change"
)
foreach ($s in $subs) {
    auditpol /set /subcategory:"$s" /success:enable /failure:enable | Out-Null
    Write-Host "Auditing enabled: $s"
}
auditpol /get /category:*
