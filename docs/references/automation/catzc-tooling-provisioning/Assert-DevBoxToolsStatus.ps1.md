# automation/Catzc.Tooling.Provisioning/Assert-DevBoxToolsStatus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts all tools are available at the correct version.

### description

Calls Get-ToolsStatus and throws if any tool is Missing or WrongVersion.
Tools with status OK or Usable pass — the tool works regardless of how
it was installed. Chocolatey status is ignored.

### example 1

```powershell
Assert-DevBoxToolsStatus
```
