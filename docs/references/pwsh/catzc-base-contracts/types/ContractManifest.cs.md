# pwsh/Catzc.Base.Contracts/types/ContractManifest.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A version folder's contract.yml, at contracts/<unit>/<version>/contract.yml
([ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)): the exceptions to the direction
convention. It mirrors the YAML mapping, so the property is snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
  direction  a map of an asset's path under the version folder (<module>/<path>, '/'-separated) to its direction,
             provided or depended-on. Optional; absent means no override.
Construction validates the file and collects every violation into one ArgumentException; an unknown key throws.
That every named asset exists is Get-Contract's check, since only the enumeration knows the assets.
```
