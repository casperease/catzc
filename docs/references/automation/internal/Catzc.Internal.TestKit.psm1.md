# automation/.internal/Catzc.Internal.TestKit.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`.

```text
Catzc.Internal.TestKit — an on-demand fixture library for Pester tests.

Many tests stand up a synthetic repository on disk: a temp root, an automation/<module> tree, and
$env:RepositoryRoot pointed at it (restored afterwards). This centralizes that boilerplate. It is a .internal
shared module (dot-prefixed, so the module conventions — one-function-per-file, Verb-Noun-only exports — do
not apply; this is a multi-function fixture helper). It is NOT loaded by the importer at startup — a test
loads it on demand through the loader, in BeforeAll, and it stays for the session:

  BeforeAll {
      Import-InternalModule TestKit
      $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Base.Alpha' = @{ Public = 'Get-Alpha' } }
  }
  AfterAll { Remove-FakeRepositoryRoot $script:fake }
```

## comment:2

Above `$saved = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot =...`.

```text
Both roots move together, so the fake tree reads as source mode (Get-CatzcRunMode compares them,
[ADR-DSGN-RUNMODE#4](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode4)): the code root is the fake
repository's own automation/ folder.
```

## comment:3

Section `.DESCRIPTION` of the comment-based help.

```text
Runs Build-Modules (Catzc.Base.Exporter) with the 'full' vendor policy — so Pester and PSScriptAnalyzer ship
with the build — into <temp>/catzc-built-<guid>/. -Module and -ModuleProfile combine as in Build-Modules;
neither builds the default bundle's profile. The build is never loaded into this session: a test reaches
it only through Invoke-InBuiltCatzc's child pwsh, because loaded assemblies and $env: are process-global
([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)). WorkingRoot is the
-RepositoryRoot the child passes to Import-Catzc.ps1 — the current
repository root by default, so out/ and test fixtures keep resolving there. Building reads the source tree,
so the session must be in source mode.
```

## comment:4

Section `.DESCRIPTION` of the comment-based help.

```text
The child runs `pwsh -NoProfile -NonInteractive -File <runner>`; the runner dot-sources
<BuildRoot>/Import-Catzc.ps1 -RepositoryRoot <WorkingRoot>, then invokes the block with -ArgumentList.
The block's output — or the error it threw — travels back through a CliXml file, never stdout, so the
importer's own console lines cannot corrupt it. Values cross the process boundary serialized (CliXml):
strings, numbers, and collections of them round-trip as themselves; richer objects arrive as property
bags. The block cannot see the caller's variables; pass them with -ArgumentList. A throw inside the
block, or a child that never wrote its result, throws here with the child's error and output tail.
```
