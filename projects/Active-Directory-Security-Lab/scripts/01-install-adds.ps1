# Run on a fresh Windows Server 2022 VM (as Administrator). Lab use only.
# Creates a new forest "lab.local". The server restarts automatically.
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

$dsrm = Read-Host "Enter Directory Services Restore Mode password" -AsSecureString
Install-ADDSForest `
    -DomainName "lab.local" `
    -DomainNetbiosName "LAB" `
    -SafeModeAdministratorPassword $dsrm `
    -InstallDns `
    -Force
