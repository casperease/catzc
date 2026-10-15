---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/tests/Get-CSharpTypeDependency.Tests.ps1.md
    kind: test-asset
    body_sha: c30dadccc935
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.TypesSystem/tests/Get-CSharpTypeDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function New-TypeModule {`.

```text
Writes <root>/<module>/types/<type>.cs for each entry. Module names double as namespaces.
[System.IO] rather than New-Item/Set-Content — ~0.1ms vs ~20ms/call
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```
