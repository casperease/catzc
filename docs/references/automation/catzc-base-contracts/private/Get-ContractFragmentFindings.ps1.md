# automation/Catzc.Base.Contracts/private/Get-ContractFragmentFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks that a fragment asset's target exists and contains the fragment, and returns the findings.

### description

The fragment check of [ADR-REPO-CONTRACT#6](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract6). The target must first be
present, with the exact case of its path (Get-ContractPresenceFindings); a missing target is the only finding, since there is nothing to
compare. Then, by the target's format (Get-ContractDataFormat):

- Json or Yaml: both files are parsed and compared as a key subset (ContractFragment.MatchData: every key path of the fragment exists in the
  target, a scalar equals, an array element is matched by some target element, a null pins the key only). A file that does not parse is the
  finding.
- any other text: every non-blank fragment line appears in the target in order, not necessarily adjacent, with trailing whitespace trimmed
  (ContractFragment.MatchLines).

### parameter RepositoryRoot

The repository root the asset and its target are relative to.

### parameter Asset

The fragment asset.

### outputs

`[string[]]` The findings; none when the target contains the fragment.

### example 1

```powershell
Get-ContractFragmentFindings -RepositoryRoot $root -Asset $asset
```
