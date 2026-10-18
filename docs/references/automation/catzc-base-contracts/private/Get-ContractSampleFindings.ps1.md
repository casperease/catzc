# automation/Catzc.Base.Contracts/private/Get-ContractSampleFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks that a sample payload parses, and validates against the schema beside it when one exists; returns the findings.

### description

The sample check of [ADR-REPO-CONTRACT#6](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract6).
A sample payload `<name>.sample.<ext>` must be JSON or YAML by its extension and parse. When `<name>.schema.json`
sits in the same folder, with exactly that case (the rule Get-Contract uses to aim that schema at the sample), the
sample also validates against it (Get-ContractSchemaFindings). That the owning module produces or parses the sample
is the module's own tests' work, not this check's.

### parameter RepositoryRoot

The repository root the asset is relative to.

### parameter Asset

The sample payload asset.

### outputs

`[string[]]` The findings; none when the sample parses and validates.

### example 1

```powershell
Get-ContractSampleFindings -RepositoryRoot $root -Asset $asset
```
