# automation/Catzc.Base.Contracts/private/Get-ContractCheckResult.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks one contract asset against the repository by its kind, and returns the result.

### description

Runs the check of the asset's kind ([ADR-REPO-CONTRACT#6](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract6)):

- Presence: the target exists with the exact case of its path (Get-ContractPresenceFindings);
- Fragment: the target exists and contains the fragment (Get-ContractFragmentFindings);
- Schema on a real file: the target exists and validates against the schema (Get-ContractSchemaFindings);
- Schema on a sample payload (its target is a sample under the asset's own module folder): the schema is well-formed
  and uses the supported keywords only; the sample is not validated here, since its own check does that, so a
  defect gives one finding on one result;
- Sample: the payload parses, and validates against the schema beside it (Get-ContractSampleFindings).
- Command: the command's file exists and declares the signature the contract states
  (Get-ContractCommandFindings,
  [ADR-REPO-CMDCONTRACT#4](../../../../adr/repository/command-contracts.md#rule-adr-repo-cmdcontract4)).

A failed check is findings on the result, never an exception.

### parameter RepositoryRoot

The repository root the asset and its target are relative to.

### parameter Asset

The asset to check.

### outputs

`[Catzc.Base.Contracts.ContractCheckResult]`

### example 1

```powershell
Get-ContractCheckResult -RepositoryRoot $root -Asset $asset
```
