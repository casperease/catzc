# pwsh/Catzc.Azure.Cli/Test-AzCliExtension.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether an Azure CLI extension is installed.

### description

Returns $true if the named extension is installed, $false otherwise. Uses `az extension show` (a core command) and inspects the exit code,
so it never throws on a missing extension and never triggers a dynamic install. Companion to Assert-AzCliExtension, mirroring the
Test-/Assert-AzCliConnected pair.

### parameter `Name`

The extension name (e.g. 'ip-group').

### outputs

System.Boolean

### example 1

```powershell
if (Test-AzCliExtension 'ip-group') { '...installed' }
```
