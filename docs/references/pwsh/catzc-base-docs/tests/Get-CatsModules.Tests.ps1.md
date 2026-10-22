---
catzc:
  edges:
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
      - ADR-PWSH-PESTER-PRIVATETHROUGHMODULE
---

# pwsh/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-CatsModules' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-CatsModules is private, so it is exercised through the module (& (Get-Module …), per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)).
```

## comment:2

Above `$script:modulesRoot = Join-Path $TestDrive 'modules'`, written with `#`.

```text
Fixture modules loaded from a fixture code root: two catzc-shaped modules, one dot-prefixed
infrastructure module, and one module loaded from outside the root.
```

## comment:3

Above `Describe 'Get-CatsModules — loaded catzc modules' -Tag 'L1', 'integrity',...`, written with `#`.

```text
Reads the REAL loaded session (nothing mocked), so it runs in both the source run and the build run and
proves Show-Cats lists the modules of whichever tree is loaded
([ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)).
```
