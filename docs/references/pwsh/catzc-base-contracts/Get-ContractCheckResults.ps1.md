# pwsh/Catzc.Base.Contracts/Get-ContractCheckResults.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks contract assets against the real repository and returns one result per asset.

### description

Contracts are binding ([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../adr/repository/api-contracts.md#rule-adr-repo-contract-provenbytests)):
each asset is checked by its kind
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)) and gives one
ContractCheckResult — Passed, and every finding as a precise message.

- Presence: the target file exists, with the exact case of its path, checked against the directory listing.
- Fragment: the target exists and contains the fragment. JSON and YAML compare as a key subset: every key path of the fragment exists in the
  target; a scalar equals the target's; each element of a fragment array is matched by at least one target element, in any order; a null
  pins its key only. Any other text: every non-blank fragment line appears in the target in order, not necessarily adjacent, trailing
  whitespace trimmed.
- Schema: the target exists and validates against the schema, YAML parsed first, by a bounded JSON Schema subset (type, required,
  properties, additionalProperties as a boolean, enum, items as one schema, const). The annotation keywords $schema, $id, $comment, title,
  description and examples are ignored by name and never constrain a value; any other keyword is a finding, never ignored. A schema whose
  target is the sample payload beside it is only checked to be well-formed in that subset: the sample's own check validates the sample, so a
  defect gives one finding, on one result.
- Sample: the payload parses as JSON or YAML by its extension, and validates against the `<name>.schema.json` beside it when one exists.
- Command: the command's file exists under the module's root and its parsed signature declares what the contract states, parameter by
  parameter and the output type
  ([ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE](../../../adr/repository/command-contracts.md#rule-adr-repo-cmdcontract-checkerperlanguage)).

The assets come from the pipeline (Get-Contract) or -Asset; with neither, every asset of every unit's draft, 0.0.0, is checked. A failed
check is a result with Passed false, never an exception; only misuse throws (a null asset, a repository root that does not exist). This
returns records rather than a boolean, so it is a Get- and not a Test-
([ADR-PWSH-VERBS-SEMANTICCONTRACT](../../../adr/automation/pwsh/respect-pwsh-verb-rules.md#rule-adr-pwsh-verbs-semanticcontract)), and the
noun is plural for the collection it returns
([ADR-PWSH-VERBS-PLURALCOLLECTIONNOUNS](../../../adr/automation/pwsh/respect-pwsh-verb-rules.md#rule-adr-pwsh-verbs-pluralcollectionnouns)).

### parameter `Asset`

The assets to check. Default: Get-Contract's assets, every unit's draft.

### parameter `RepositoryRoot`

The repository root that holds contracts/ and the target files. Default: the loaded repository root.

### outputs

`[Catzc.Base.Contracts.ContractCheckResult[]]` in the order the assets arrive.

### example 1

```powershell
Get-ContractCheckResults
```

### example 2

```powershell
Get-Contract -Module Catzc.Tooling.Github | Get-ContractCheckResults | Where-Object { -not $_.Passed }
```
