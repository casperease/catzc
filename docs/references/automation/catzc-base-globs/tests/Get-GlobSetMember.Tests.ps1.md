---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
    kind: test-asset
    body_sha: b7e816c03181
    adrs:
      - ADR-FLOW-CD-GLOBS#4
---

# automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-GlobSetMember' -Tag 'L0', 'logic' {`.

```text
The single 'what is IN the package' source
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): `git ls-files` ∩
GlobSet.Matches, ordinal-sorted.
Tested through the module (private). The '_' args in the scriptblock take the set and mocked tree.
```
