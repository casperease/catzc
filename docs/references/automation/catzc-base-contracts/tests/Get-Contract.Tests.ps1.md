---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/Get-Contract.Tests.ps1.md
    kind: test-asset
    body_sha: "931dddaa63e8"
---

# automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-Contract' -Tag 'L0', 'logic' {`.

```text
Get-Contract lists contracts/<unit>/<version>/<module>/<path> and derives every fact from the asset's name and place
([ADR-REPO-CONTRACT](/docs/adr/repository/api-contracts.md)): the target under the module's target root (#2), the kind
from the suffix (#6), the direction from the convention and the version's contract.yml (#7), and the addressing mode
from the config (#8). Fixtures are a widget repository in TestDrive.
```
