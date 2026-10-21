# pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ModuleGlobSet' -Tag 'L1', 'logic' {`, written with `#`.

```text
The derived globsets ([ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](/docs/drs/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets)): folder
= module = set (readme-kebab name), one single-file set per
internal .psm1 module, reserved infra scopes, one shared name space with the declared registry. Derived
sets never enter GlobsConfig but scope protection and blast radius through the same Matches() machinery.
```

## comment:2

Above `$script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{`, written with `#`.

```text
Neutral fixture globset name (widget), not the real 'automation' set
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); this declared
set only needs to exist so the shadow-check has a registry to compare the derived names against.
```

## comment:3

Above `Describe 'GlobsConfig reserved names' -Tag 'L0', 'logic' {`, written with `#`.

```text
The reserved-name guard lives in the registry type itself
([ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](/docs/drs/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets)).
```
