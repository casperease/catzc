---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-ReadmeMappings.Tests.ps1.md
    kind: test-asset
    body_sha: "6013a1744367"
    adrs:
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-ReadmeMappings.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ReadmeMappings' -Tag 'L0', 'logic' {`.

```text
Get-ReadmeMappings is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)).
```

## comment:2

Above `$script:root = Join-Path $TestDrive ([guid]::NewGuid())`.

```text
Fixture repo: automation/<modules> + a dot-dir; reference articles, as the sources, for two of the three
modules.
```

## comment:3

Above `InModuleScope Catzc.Base.Docs {`.

```text
No Root plumbing: the glob-shape check throws before RepositoryRoot is ever read, so a literal
placeholder root is enough here.
```
