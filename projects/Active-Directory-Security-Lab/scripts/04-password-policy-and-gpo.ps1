# Domain password/lockout policy + two example GPOs
Import-Module ActiveDirectory, GroupPolicy
$base = "OU=LabCorp,DC=lab,DC=local"

# 1) Domain password and lockout policy
Set-ADDefaultDomainPasswordPolicy -Identity "lab.local" `
    -MinPasswordLength 12 `
    -ComplexityEnabled $true `
    -PasswordHistoryCount 24 `
    -MaxPasswordAge 90.00:00:00 `
    -LockoutThreshold 5 `
    -LockoutDuration 00:30:00 `
    -LockoutObservationWindow 00:30:00

# 2) GPO: lock the screen after 10 minutes (applies to users)
$g1 = New-GPO -Name "LAB-User-ScreenLock"
$key = "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop"
Set-GPRegistryValue -Name $g1.DisplayName -Key $key -ValueName ScreenSaveActive    -Type String -Value "1"
Set-GPRegistryValue -Name $g1.DisplayName -Key $key -ValueName ScreenSaverIsSecure -Type String -Value "1"
Set-GPRegistryValue -Name $g1.DisplayName -Key $key -ValueName ScreenSaveTimeOut   -Type String -Value "600"
New-GPLink -Name $g1.DisplayName -Target "OU=Users,$base"

# 3) GPO: block removable storage on computers
$g2 = New-GPO -Name "LAB-Computer-BlockUSB"
Set-GPRegistryValue -Name $g2.DisplayName `
    -Key "HKLM\Software\Policies\Microsoft\Windows\RemovableStorageDevices" `
    -ValueName Deny_All -Type DWord -Value 1
New-GPLink -Name $g2.DisplayName -Target "OU=Computers,$base"

Write-Host "Policies and GPOs applied." -ForegroundColor Green
