# automation/Catzc.Base.Exporter/private/Get-CatzcUserModulePath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the current user's PowerShell 7 module folder — where Install-Catzc -Scope CurrentUser places Catzc.

### description

The same folder PowerShell itself puts first on a user's PSModulePath: `<Documents>/PowerShell/Modules` on Windows,
`<LocalApplicationData>/powershell/Modules` (~/.local/share/powershell/Modules) elsewhere.
