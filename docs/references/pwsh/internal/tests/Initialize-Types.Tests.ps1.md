# pwsh/.internal/tests/Initialize-Types.Tests.ps1

<!-- cspell:ignore inittypes enabletypes FIXTUREWIDGET -->

The tests of `Initialize-Types`, which reads a loaded assembly's manifest and registers its aliases and display sets.

## Fixtures

The cases are L1: each loads a fixture DLL, so the file is locked for the process lifetime. The fixtures live outside `TestDrive`, in a
self-managed temp directory cleaned best-effort. The pending record and the lookup hook are session state: saved, replaced by a fresh record
per case and restored after.

`New-FixtureAssembly` writes a fixture with a manifest written by hand, as the builder would: one type with an alias and a display set, one
plain. `New-PendingFixture` gives each case its own assembly, because a loaded type cannot be unloaded and a shared one would be loaded by
the first case.
