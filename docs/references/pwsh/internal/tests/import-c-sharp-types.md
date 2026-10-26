# pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1

<!-- cspell:ignore importcs dlllock -->

The tests of `Import-CSharpTypes`, which compiles the modules' C# types into one combined assembly and loads it.

## Fixtures

The fixtures live outside `TestDrive`: `Add-Type` loads each compiled DLL into the process, so the file is locked for the process lifetime
and can never be deleted in-session. `TestDrive`'s mandatory teardown would fail on the lock, so a self-managed temp directory is cleaned
best-effort and leaks only the DLL. Loads go through the per-user shadow copy (`Import-TypesAssembly`), kept under the fixture root and out
of the real `%LOCALAPPDATA%\catzc\types`, since a loaded copy stays locked too.

The module and type suffix is unique per run. .NET types persist for the whole process, so a fixed name would already be loaded on a second
run in the same session, and the loader would take its no-op branch and skip the compile.

`New-FixtureRoot` writes a modules root: one subfolder per module in `$Modules`, keyed by module name, each with `types/<name>.cs` for every
entry in its value hashtable, keyed by the bare type name. Sources mirror shipped types: each declares its module's file-scoped namespace,
which the loader requires, so the builder prepends `namespace <module>;` unless the case already supplies a namespace line (the negative
tests ship a wrong or block-scoped one to exercise the check). It returns the root to pass as `-ModulesRoot`, and `Import-CSharpTypes`
writes the combined assembly to `<root>/.compiled/`. It writes with `System.IO` rather than `New-Item` and `Set-Content`, about 0.1 ms
against 20 ms a call
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).
`WriteAllText` writes the string verbatim, and the prepended line uses LF, so a fixture's line endings are exactly the source's bar that one
line; the line-ending case relies on that.

The loader announces a real build through `Write-ImporterMessage`; the tests mock it so compile tests stay quiet and the announce test can
assert the call. A run from a VS Code terminal carries its mark, so every case is a plain devbox unless it sets the mark itself.

## Compile and cache

The first compile case is L1: the first `Add-Type` in the file pays Roslyn's cold start (about 0.5 s) on top of the compile itself, and the
sibling compile tests run against a warm compiler and stay within the L0 budget. It compiles fresh modules, loads their types and caches one
combined DLL.

## Line endings

The combined hash is insensitive to line endings, so a checkout under git `core.autocrlf`, or an editor re-saving a file, that flips line
endings must not be mistaken for a source change. The case flips a fixture's endings and expects no `changed since they were loaded` throw.

## One guard per root

The session guard is keyed by `ModulesRoot`. Loading root A, then a different root B (as the test-fixture trees do beside the real `pwsh/`
tree), must not make a re-import of root A throw a bogus "types changed". Each root tracks its own hash and snapshot.

## Devbox and pipeline

A loaded assembly cannot be swapped in-process, but a devbox degrades gracefully: it warns and keeps the already-loaded types this session.
The case clears both pipeline environment variables so it takes the devbox path even in CI.

## The namespace rule

The source must declare its module's file-scoped namespace; a different one is the mismatch the loader rejects (the invariant
`Test-Formatting` checks too), and an explicit namespace bypasses the builder's prepend. A second case bypasses `New-FixtureRoot` and writes
the source directly, so the file genuinely lacks a namespace; the loader must reject it rather than silently produce a type in the global
namespace.
