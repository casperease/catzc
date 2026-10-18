# automation/Catzc.Base.Contracts/private/Get-ContractCommandFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks a command contract against the command's file and returns the findings.

### description

The PowerShell checker of [ADR-REPO-CMDCONTRACT#4](../../../../adr/repository/command-contracts.md#rule-adr-repo-cmdcontract4). The
command's file, the asset's target, must first be present with the exact case of its path (Get-ContractPresenceFindings); a missing file is
the only finding, and when the same name sits in the module's private folder the finding says so, since a private function is no command.
Then the asset parses as the contract language (ContractCommand,
[ADR-REPO-CMDCONTRACT#2](../../../../adr/repository/command-contracts.md#rule-adr-repo-cmdcontract2)), the file's signature is read without
loading it (Read-CommandSignature), and ContractCommand.Compare gives one finding per disagreement. A contract or a file that does not parse
is the finding.

### parameter RepositoryRoot

The repository root the asset and its target are relative to.

### parameter Asset

The command contract asset.

### outputs

`[string[]]` The findings; none when the command declares what the contract says.

### example 1

```powershell
Get-ContractCommandFindings -RepositoryRoot $root -Asset $asset
```
