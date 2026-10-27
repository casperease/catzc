# pwsh/Base.Exporter/private/Get-UserModulePath.ps1

The private resolver of the current user's PowerShell 7 module folder, where `Install-Catzc -Scope CurrentUser` places Catzc.

## help

### synopsis

Returns the current user's PowerShell 7 module folder — where Install-Catzc -Scope CurrentUser places Catzc.

### description

The same folder PowerShell itself puts first on a user's PSModulePath: `<Documents>/PowerShell/Modules` on Windows,
`<LocalApplicationData>/powershell/Modules` (~/.local/share/powershell/Modules) elsewhere.
