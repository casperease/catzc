---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/tests/ConvertTo-FlatSettingSet.Tests.ps1.md
    kind: test-asset
    body_sha: fb698984adf5
---

# automation/Catzc.Base.Objects/tests/ConvertTo-FlatSettingSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `class CatzcFlatSettingSetDb {`.

```text
Real CLR types (PowerShell classes are genuine .NET types, parsed by PowerShell — no Roslyn compile) used to
prove the reflect-over-public-members path with a nested typed member. Avoids Add-Type, whose Roslyn compile
was the entire cost of this L0 file.
```
