# Creates the OU structure under DC=lab,DC=local
Import-Module ActiveDirectory
$root = "DC=lab,DC=local"

New-ADOrganizationalUnit -Name "LabCorp" -Path $root -ProtectedFromAccidentalDeletion $true
$base = "OU=LabCorp,$root"

foreach ($ou in "Users","Computers","Groups","Admins","ServiceAccounts") {
    New-ADOrganizationalUnit -Name $ou -Path $base -ProtectedFromAccidentalDeletion $true
}

foreach ($dept in "IT","HR","Finance") {
    New-ADOrganizationalUnit -Name $dept -Path "OU=Users,$base" -ProtectedFromAccidentalDeletion $true
    New-ADGroup -Name "GG-$dept" -GroupScope Global -GroupCategory Security `
        -Path "OU=Groups,$base" -Description "$dept department"
}
Write-Host "OU structure created." -ForegroundColor Green
