---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/tests/ConvertTo-FlatSettingSet.Tests.ps1.md
    folder: docs/references/automation/catzc-base-objects/tests
    name: convert-to-flat-setting-set-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8df2176d3862"
---

# automation/Catzc.Base.Objects/tests/ConvertTo-FlatSettingSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `class CatzcFlatSettingSetDb {`, written with `#`.

```text
Real CLR types (PowerShell classes are genuine .NET types, parsed by PowerShell — no Roslyn compile) used to
prove the reflect-over-public-members path with a nested typed member. Avoids Add-Type, whose Roslyn compile
was the entire cost of this L0 file.
```
