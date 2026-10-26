# pwsh/.internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1

The L0 tests of `Get-ForeignCatzcModule` and `Assert-CatzcRunModeExclusive`, which refuse a session that holds catzc modules from two code
roots.

## Fixture

Two fixture code roots, an active one and another one, each holding catzc-named modules. Beside them sit a non-catzc module and a package
module `Catzc` whose `ModuleBase` is the active root's parent, so the tests tell a foreign catzc module from the active root's own, from a
module that is not catzc at all, and from the package.
