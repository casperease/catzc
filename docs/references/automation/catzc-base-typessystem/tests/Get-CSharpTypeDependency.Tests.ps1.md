---
catzc:
  immutable:
    with_body_sha: "22bbbd8dfd28"
    repo_status: locked
    path: docs/references/automation/catzc-base-typessystem/tests/Get-CSharpTypeDependency.Tests.ps1.md
    folder: docs/references/automation/catzc-base-typessystem/tests
    name: get-c-sharp-type-dependency-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.TypesSystem/tests/Get-CSharpTypeDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-TypeModule {`, written with `#`.

```text
Writes <root>/<module>/types/<type>.cs for each entry. Module names double as namespaces.
[System.IO] rather than New-Item/Set-Content — ~0.1ms vs ~20ms/call
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```
