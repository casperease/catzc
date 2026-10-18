# pwsh/.internal/Catzc.Internal.TestKit.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`, written with `#`.

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

Above `[CmdletBinding()]`, written with `#`.

```text
.SYNOPSIS
    Fabricate one module folder under a (fake) repo root: automation/<Name>/, with public function files at
    the module root, private/<fn>.ps1 files, and any extra files (path relative to the module folder).
    Returns the module directory path.
```

## comment:3

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChan...`, written with `#`.

```text
.SYNOPSIS
    Create a fresh temp repository root, populate it, point $env:RepositoryRoot at it and $env:CatzcModulesRoot
    at its automation/ folder (so the fake tree reads as source mode), and return a handle
    { Root; Automation; Saved } to pass to Remove-FakeRepositoryRoot. -Modules maps a module name to a spec
    (@{ Public=..; Private=..; Files=.. }; $null/empty = a bare folder). -Files maps repo-root-relative
    paths to content (importer.ps1, .editorconfig, …). -WorkingRootOnly moves only $env:RepositoryRoot and
    leaves the code root on the loaded modules — for a test that writes into a fixture working root while
    reading the real assets of the loaded code (in either run mode).
```

## comment:4

Above `$saved = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot =...`, written with `#`.

```text
Both roots move together, so the fake tree reads as source mode (Get-CatzcRunMode compares them,
[ADR-DSGN-RUNMODE#4](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode4)): the code root is the fake
repository's own automation/ folder.
```

## comment:5

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChan...` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Restore $env:RepositoryRoot and $env:CatzcModulesRoot to what they were before New-FakeRepositoryRoot and
    delete the temp tree.
```

## comment:6

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChan...` (occurrence 3), written with `#`.

```text
.SYNOPSIS
    Build the selected modules into a fresh temp folder for a build-mode test, and return a handle
    { BuildRoot; WorkingRoot; Saved; Destination; Modules; Build } to pass to Invoke-InBuiltCatzc and
    Remove-BuiltCatzcRoot.
.DESCRIPTION
    The build is never loaded here: assemblies and env vars are process-global, so only a child pwsh reaches it.
    [comment:3](/docs/references/pwsh/internal/Catzc.Internal.TestKit.psm1.md#comment3)
```

## comment:7

Above `[CmdletBinding()]` (occurrence 5), written with `#`.

```text
.SYNOPSIS
    Run a script block in a child pwsh that has entered build mode through the handle's Import-Catzc.ps1, and
    return the block's output.
.DESCRIPTION
    Results return in a CliXml file, never stdout, so importer console lines cannot corrupt them.
    [comment:4](/docs/references/pwsh/internal/Catzc.Internal.TestKit.psm1.md#comment4)
```

## comment:8

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChan...` (occurrence 4), written with `#`.

```text
.SYNOPSIS
    Restore $env:RepositoryRoot and $env:CatzcModulesRoot to what they were before New-BuiltCatzcRoot and
    delete the build.
```
