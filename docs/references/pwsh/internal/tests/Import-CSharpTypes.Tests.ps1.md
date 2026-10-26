# pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1

<!-- cspell:ignore importcs dlllock -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath())...`, written with `#`.

```text
Fixtures live OUTSIDE TestDrive: Add-Type loads each compiled DLL into the process, so the file is
locked for the process lifetime and can never be deleted in-session. TestDrive's mandatory teardown
would fail on the lock; a self-managed temp dir lets us best-effort clean and leak only the DLL.
```

## comment:2

Above `$script:runId = 'r' + [guid]::NewGuid().ToString('N').Substring(0, 8)`, written with `#`.

```text
Per-run-unique module/type suffix. .NET types persist for the whole process, so a fixed name would
be already-loaded on a second test run in the same session — the loader would then take its no-op
branch and skip the compile. A fresh suffix per run keeps the "fresh type" precondition true.
```

## comment:3

Above `function New-FixtureRoot {`, written with `#`.

```text
Writes a fixture MODULES ROOT: a fresh dir containing one subfolder per module in $Modules (keyed by
module name), each with types/<name>.cs for each entry in its value hashtable (keyed by the BARE type
name). Sources mirror shipped types: each declares its module's file-scoped namespace, which the loader
requires — so New-FixtureRoot auto-prepends "namespace <module>;" UNLESS the case already supplies a
namespace line (the negative tests ship a wrong/block-scoped one to exercise the gate). Returns the root
to pass as -ModulesRoot. Import-CSharpTypes writes the combined assembly to <root>/.compiled/.
[System.IO] rather than New-Item/Set-Content — ~0.1ms vs ~20ms/call
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)). WriteAllText writes the
string verbatim (no trailing newline appended); the auto-prepend uses LF, so a fixture's line endings
are exactly the source's bar that one leading line — the CRLF/LF-flip regression below relies on that.
```

## comment:4

Above `Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Bootstrap`, written with `#`.

```text
The loader announces a real build via Write-ImporterMessage. Mock it so compile tests stay quiet,
and so the announce test can assert the call.
```

## comment:5

Above `$shadowRoot = Join-Path $script:fixtureRoot 'shadow'`, written with `#`.

```text
Loads go through the per-user shadow copy (Import-TypesAssembly); keep the fixtures' copies out of the
real %LOCALAPPDATA%\catzc\types. Under fixtureRoot, not TestDrive: a loaded copy stays locked too.
```

## comment:6

Above `It 'compiles fresh modules, loads their types, and caches ONE combined DLL'...`, written with `#`.

```text
L1: the first Add-Type in the file pays Roslyn's cold-start (~0.5s) on top of the compile itself;
the sibling compile tests run against a warm compiler and stay within the L0 budget.
```

## comment:7

Above `$namespace = "CatzcTestEol$runId"`, written with `#`.

```text
Regression: the combined hash is EOL-insensitive, so a checkout under git core.autocrlf (or an editor
re-saving the file) that flips line endings must NOT be mistaken for a source change. Before the fix
this threw '*changed since they were loaded*' even though the content was byte-identical bar EOLs.
```

## comment:8

Above `$namespaceA = "CatzcTestRootA$runId"`, written with `#`.

```text
Regression: the session guard is keyed by ModulesRoot. Loading root A, then a DIFFERENT root B
(this is exactly what the test-fixture trees do vs the real pwsh/ tree), must NOT make a
re-import of root A throw a bogus "types changed". Before the fix a single global was overwritten
by the last root loaded, so the next real import after a test run threw on session-leaked
fixture state. Each root must track its own hash/snapshot.
```

## comment:9

Above `$savedTfBuild = $env:TF_BUILD`, written with `#`.

```text
A loaded assembly cannot be swapped in-process, but a devbox degrades gracefully: warn and keep the
already-loaded types this session. Clear BOTH pipeline env vars so this is the devbox path even in CI.
```

## comment:10

Above ``$root = New-FixtureRoot @{ $namespace = @{ Widget = "namespace Other;`npublic...``, written with `#`.

```text
The source must declare its module's file-scoped namespace; a different one is the mismatch the
loader rejects (the same invariant Test-Formatting checks). The explicit namespace bypasses auto-prepend.
```

## comment:11

Above `$root = Join-Path $script:fixtureRoot ([guid]::NewGuid().ToString('N'))` (occurrence 2), written with `#`.

```text
Bypass New-FixtureRoot's auto-prepend by writing the source directly, so the file genuinely lacks
a namespace — the loader must reject it rather than silently produce a type in the global namespace.
```

## comment:12

Above `$script:originalTerminalProgram = $env:TERM_PROGRAM`, written with `#`.

```text
A run from a VS Code terminal carries its mark; every case here is a plain devbox unless it sets the mark
itself.
```
