---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-CatsModules.Tests.ps1.md
    kind: test-asset
    body_sha: "5ff8eb045eed"
    adrs:
      - ADR-AUTO-ASSETDEP#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-CatsModules' -Tag 'L0', 'logic' {`.

```text
Get-CatsModules is private, so it is exercised through the module (& (Get-Module …), per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)).
```

## comment:2

Above `$script:modulesRoot = Join-Path $TestDrive 'modules'`.

```text
Fixture modules loaded from a fixture code root: two catzc-shaped modules, one dot-prefixed
infrastructure module, and one module loaded from outside the root.
```

## comment:3

Above `Describe 'Get-CatsModules — loaded catzc modules' -Tag 'L1', 'integrity',...`.

```text
Reads the REAL loaded session (nothing mocked), so it runs in both the source run and the build run and
proves Show-Cats lists the modules of whichever tree is loaded
([ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3)).
```
