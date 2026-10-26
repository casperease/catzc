# pwsh/.internal/tests/Import-CSharpTypes.CrossRoot.Tests.ps1

<!-- cspell:ignore importcs dlllock -->

The tests of `Import-CSharpTypes` across code roots: two roots compiling the same type names into one process.

## Fixtures outside TestDrive

`Add-Type` loads each compiled DLL into the process, so the file is locked for the process lifetime and can never be deleted in-session.
`TestDrive`'s mandatory teardown would fail on the lock, so the fixtures live in a self-managed temp directory that is cleaned best-effort,
leaking only the DLL. Loads go through the per-user shadow copy (`Import-TypesAssembly`); the shadow root sits under the fixture root too,
which keeps the fixtures' copies out of the real `%LOCALAPPDATA%\catzc\types`, and for the same reason: a loaded copy stays locked.

## A fresh name per run

The module and type suffix is unique per run. .NET types persist for the whole process, so a fixed name would already be loaded on a second
run in the same session, and the loader would take its no-op branch and skip the compile. A fresh suffix keeps the "fresh type" precondition
true.

## The fixture builder

`New-FixtureRoot` writes a modules root: a fresh directory with one subfolder per module in `$Modules`, keyed by module name, each holding
`types/<name>.cs` for every entry in its value hashtable, keyed by the bare type name. Sources mirror shipped types: each declares its
module's file-scoped namespace, which the loader requires, so the builder prepends `namespace <module>;` unless the case already supplies a
namespace line (the negative tests ship a wrong or block-scoped one to exercise the check). It returns the root to pass as `-ModulesRoot`,
and `Import-CSharpTypes` writes the combined assembly to `<root>/.compiled/`.

It writes with `System.IO` rather than `New-Item` and `Set-Content`, about 0.1 ms against 20 ms a call
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).
`WriteAllText` writes the string verbatim with no trailing newline, and the prepended line uses LF, so a fixture's line endings are exactly
the source's bar that one leading line; the CRLF and LF flip regression test relies on that.

## What is mocked and read

The loader announces a real build through `Write-ImporterMessage`; the tests mock it so compile tests stay quiet and the announce test can
assert the call. `Get-TypeRecord` reads the loader's per-root session record (the session-global `__CatzcTypes`) without a `$global:`
reference: the record for a root, or `$null` when that root never recorded. A run from a VS Code terminal carries its mark, so every case is
a plain devbox unless it sets the mark itself.

## Two roots, one type name

The two run modes compile their DLLs from the same `types/*.cs`. A root loading after another has put the same type names in the AppDomain
compares per-file digests against that root's record: equal digests reuse, and different ones (or a needed type missing) take the
stale-types contract and name both roots.
