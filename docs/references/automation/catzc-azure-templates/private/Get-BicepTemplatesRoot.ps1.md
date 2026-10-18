# automation/Catzc.Azure.Templates/private/Get-BicepTemplatesRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the root directory under which bicep templates are discovered.

### description

The single seam for _where_ Get-BicepTemplates scans: $(Get-RepositoryRoot)/infrastructure/templates.
Production has exactly one answer. Tests redirect discovery to a fixture tree by mocking this
function (`Mock Get-BicepTemplatesRoot -ModuleName Catzc.Azure.Templates`), so unit tests never depend on
the real, shipped templates under infrastructure/templates/. Get-BicepTemplates keys its session
cache on this value, so a fixture root and the real root never collide.

### example 1

```powershell
Get-BicepTemplatesRoot   # -> <repo>/infrastructure/templates
```
