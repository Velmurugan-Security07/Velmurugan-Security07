# Bulk-creates lab users from users.csv (fictional names). Run on the domain controller.
Import-Module ActiveDirectory
$base = "OU=LabCorp,DC=lab,DC=local"
$pw   = Read-Host "Initial password for new users" -AsSecureString

Import-Csv "$PSScriptRoot\users.csv" | ForEach-Object {
    $ou = "OU=$($_.Department),OU=Users,$base"
    New-ADUser `
        -Name "$($_.FirstName) $($_.LastName)" `
        -GivenName $_.FirstName -Surname $_.LastName `
        -SamAccountName $_.Username `
        -UserPrincipalName "$($_.Username)@lab.local" `
        -Department $_.Department `
        -Path $ou `
        -AccountPassword $pw `
        -ChangePasswordAtLogon $true `
        -Enabled $true
    Add-ADGroupMember -Identity "GG-$($_.Department)" -Members $_.Username
    Write-Host "Created $($_.Username) in $($_.Department)"
}
