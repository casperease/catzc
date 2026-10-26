# pwsh/.internal/tests/Import-CSharpTypes.CrossRoot.Tests.ps1

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

Above `BeforeAll {` (occurrence 2), written with `#`.

```text
The two run modes compile their DLLs from the same types/*.cs, so a root loading AFTER another root has
put the same type names in the AppDomain compares per-file digests against that root's record: equal
reuses, different (or a needed type missing) takes the stale-types contract and names both roots.
```

## comment:7

Above `function Get-TypeRecord {`, written with `#`.

```text
The loader's per-root session record (the session-global __CatzcTypes), read without a $global:
reference: the record for <Root>, or $null when that root never recorded.
```

## comment:8

Above `$script:originalTerminalProgram = $env:TERM_PROGRAM`, written with `#`.

```text
A run from a VS Code terminal carries its mark; every case here is a plain devbox unless it sets the mark
itself.
```
