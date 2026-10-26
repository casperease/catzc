# pwsh/.internal/tests/Initialize-Types.Tests.ps1

<!-- cspell:ignore inittypes enabletypes FIXTUREWIDGET -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
L1: each case loads a fixture DLL, so the file is locked for the process lifetime. Fixtures live OUTSIDE TestDrive, in a
self-managed temp dir cleaned best-effort. The pending record and the lookup hook are session state: saved, replaced by
a fresh record per case, and restored after.
```

## comment:2

Above `function script:New-FixtureAssembly {`, written with `#`.

```text
A fixture with a manifest written by hand, as the builder would: one type with an alias and a display set, one
plain.
```

## comment:3

Above `function script:New-PendingFixture {`, written with `#`.

```text
Each case gets its own assembly: a loaded type cannot be unloaded, so a shared one would be loaded by the
first case.
```
