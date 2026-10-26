# pwsh/Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1

The tests of `Get-ModuleGlobSet`, the derived globsets
([ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets)).

## What it proves

A folder is a module is a set, with a readme-kebab name. Each internal `.psm1` module has one single-file set, the reserved infra scopes are
derived, and the derived names share one name space with the declared registry. Derived sets never enter `GlobsConfig`, but they bound
protection and blast radius through the same `Matches()` machinery.

## Fixtures

The fixture globset name is neutral (widget), not the real `automation` set
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). The
declared set only needs to exist so that the shadow check has a registry to compare the derived names against.

## Reserved names

The reserved-name guard lives in the registry type itself
([ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets)).
