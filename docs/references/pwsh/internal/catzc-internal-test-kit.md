# pwsh/.internal/Catzc.Internal.TestKit.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

An on-demand Pester fixture library. Many tests stand up a synthetic repository on disk — a temp root, a `pwsh/<module>` tree, and
`$env:RepositoryRoot` pointed at it (restored afterward) — and this module centralizes that boilerplate. Unlike the other `.internal` shared
modules it is **not loaded by the importer at startup**: a test loads it on demand through `Import-InternalModule TestKit` in `BeforeAll`,
and it stays for the session. Being a `.internal` shared module (dot-prefixed), the module conventions — one-function-per-file and
Verb-Noun-only exports — do not apply to it: it is a deliberate multi-function fixture helper.

## What it does

The fixtures fabricate a throwaway repository so a test can exercise discovery, manifest generation, or anything that anchors on
`$env:RepositoryRoot` without touching the real tree:

- `New-FakeRepositoryRoot` creates a fresh temp repository root, populates it from a `-Modules` map (each entry a module name and an
  optional spec of public/private function names and extra files) and a `-Files` map (repo-root-relative paths and content — `importer.ps1`,
  `.editorconfig`, …), points `$env:RepositoryRoot` at it, and returns a handle `{ Root; ModulesRoot; Saved }`.
- `New-ModuleFolder` fabricates one module folder under a root: `pwsh/<Name>/` with public function files at the module root,
  `private/<fn>.ps1` files, and any extra files placed relative to the module folder. It returns the module directory path.
- `Remove-FakeRepositoryRoot` restores `$env:RepositoryRoot` to what it was before and deletes the temp tree — the `AfterAll` counterpart.

The usage shape is a `BeforeAll` that imports the kit and stands up the root, and an `AfterAll` that tears it down:

```powershell
BeforeAll {
    Import-InternalModule TestKit
    $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Base.Alpha' = @{ Public = 'Get-Alpha' } }
}
AfterAll { Remove-FakeRepositoryRoot $script:fake }
```

## Functions

- `New-FakeRepositoryRoot` — create, populate, and activate a temp repository root; returns a handle for teardown.
- `New-ModuleFolder` — fabricate one `pwsh/<Name>/` module folder with public, private, and extra files.
- `Remove-FakeRepositoryRoot` — restore `$env:RepositoryRoot` and delete the temp tree.

## Related

- ADR: [test-automation](../../../drs/automation/test-automation.md) — isolating logic tests behind seams, which these fixtures provide.
- ADR: [one-living-version](../../../drs/principles/one-living-version.md) and
  [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md) — why a multi-function `.internal` `.psm1` is sanctioned here.
- Reference: [Catzc.Internal.Loader](catzc-internal-loader.md) — `Import-InternalModule TestKit` loads it; the
  [internal area overview](index.md).

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`, written with `#`.

```text
Catzc.Internal.TestKit — an on-demand fixture library for Pester tests.

Many tests stand up a synthetic repository on disk: a temp root, a pwsh/<module> tree, and
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
    Fabricate one module folder under a (fake) repo root: pwsh/<Name>/, with public function files at
    the module root, private/<fn>.ps1 files, and any extra files (path relative to the module folder).
    Returns the module directory path.
```

## comment:3

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChan...`, written with `#`.

```text
.SYNOPSIS
    Create a fresh temp repository root, populate it, point $env:RepositoryRoot at it and $env:CatzcModulesRoot
    at its pwsh/ folder (so the fake tree reads as source mode), and return a handle
    { Root; ModulesRoot; Saved } to pass to Remove-FakeRepositoryRoot. -Modules maps a module name to a spec
    (@{ Public=..; Private=..; Files=.. }; $null/empty = a bare folder). -Files maps repo-root-relative
    paths to content (importer.ps1, .editorconfig, …). -WorkingRootOnly moves only $env:RepositoryRoot and
    leaves the code root on the loaded modules — for a test that writes into a fixture working root while
    reading the real assets of the loaded code (in either run mode).
```

## comment:4

Above `$saved = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot =...`, written with `#`.

```text
Both roots move together, so the fake tree reads as source mode (Get-CatzcRunMode compares them,
[DDR-RUNMODE-MODEISDERIVED](/docs/drs/design/run-modes.md#rule-ddr-runmode-modeisderived)): the code root is the fake
repository's own pwsh/ folder.
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
