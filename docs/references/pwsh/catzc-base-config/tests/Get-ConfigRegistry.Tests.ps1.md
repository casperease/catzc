# pwsh/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ConfigRegistry'`, written with `#`.

```text
Get-ConfigRegistry is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)).
Each test resets the session's cache entry before and after
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)), so a fixture
registry never
leaks into the rest of the run.
```

## comment:2

Above `Describe 'Get-ConfigRegistry — shipped configs.yml'`, written with `#`.

```text
Reads the SHIPPED configs.yml through the real lookup (nothing mocked), so it runs in both the source run
and the build run and proves the registry resolves inside the loaded module
([ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)).
```

## comment:3

Above `Describe 'Get-ConfigRegistry'`, written with `#`.

```text
Private, so reached through the module; the session's cache entry is reset around each case, so a fixture registry
never leaks.
```

## comment:4

Above `Describe 'Get-ConfigRegistry — shipped configs.yml'`, written with `#`.

```text
The shipped registry through the real lookup, nothing mocked, so it proves the registry resolves inside a loaded build
too.
```
