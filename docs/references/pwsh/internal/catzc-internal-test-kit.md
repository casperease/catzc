# pwsh/.internal/Catzc.Internal.TestKit.psm1

An on-demand Pester fixture library. Many tests stand up a synthetic repository on disk — a temp root, a `pwsh/<module>` tree, and
`$env:RepositoryRoot` pointed at it (restored afterward) — and this module centralizes that boilerplate. Unlike the other `.internal` shared
modules it is **not loaded by the importer at startup**: a test loads it on demand through `Import-InternalModule TestKit` in `BeforeAll`,
and it stays for the session. Being a `.internal` shared module (dot-prefixed), the module conventions — one-function-per-file and
Verb-Noun-only exports — do not apply to it: it is a deliberate multi-function fixture helper.

## What it does

The fixtures fabricate a throwaway repository so a test can exercise discovery, manifest generation, or anything that anchors on
`$env:RepositoryRoot` without touching the real tree:

- `New-FakeRepositoryRoot` creates a fresh temp repository root, populates it from a `-Modules` map (each entry a module name and an
  optional spec of public/private function names and extra files; `$null` or empty is a bare folder) and a `-Files` map (repo-root-relative
  paths and content — `importer.ps1`, `.editorconfig`, …), points `$env:RepositoryRoot` at it, and returns a handle
  `{ Root; ModulesRoot; Saved }`.
- `New-ModuleFolder` fabricates one module folder under a root: `pwsh/<Name>/` with public function files at the module root,
  `private/<fn>.ps1` files, and any extra files placed relative to the module folder. It returns the module directory path.
- `Remove-FakeRepositoryRoot` restores `$env:RepositoryRoot` and `$env:CatzcModulesRoot` to what they were before and deletes the temp tree
  — the `AfterAll` counterpart.

The usage shape is a `BeforeAll` that imports the kit and stands up the root, and an `AfterAll` that tears it down:

```powershell
BeforeAll {
    Import-InternalModule TestKit
    $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Base.Alpha' = @{ Public = 'Get-Alpha' } }
}
AfterAll { Remove-FakeRepositoryRoot $script:fake }
```

## Roots in a fake tree

`New-FakeRepositoryRoot` moves both roots together, `$env:RepositoryRoot` and `$env:CatzcModulesRoot` (the fake repository's own `pwsh/`
folder), so the fake tree reads as source mode (`Get-CatzcRunMode` compares them,
[DDR-RUNMODE-MODEISDERIVED](../../../drs/design/run-modes.md#rule-ddr-runmode-modeisderived)). `-WorkingRootOnly` moves only
`$env:RepositoryRoot` and leaves the code root on the loaded modules, for a test that writes into a fixture working root while reading the
real assets of the loaded code in either run mode.

## Build-mode fixtures

- `New-BuiltCatzcRoot` builds the selected modules (`-Module`, `-ModuleProfile`) with `Build-Modules` into a fresh temp folder and returns a
  handle `{ BuildRoot; WorkingRoot; Saved; Destination; Modules; Build }`. It throws when `Build-Modules` (`Catzc.Base.Exporter`) is not
  loaded. The build is never loaded in the test's own process: assemblies and environment variables are process-global, so only a child
  `pwsh` reaches it.
- `Invoke-InBuiltCatzc` runs a script block in a child `pwsh` that has entered build mode through the handle's `Import-Catzc.ps1`, and
  returns the block's output. Results return in a CliXml file, never stdout, so importer console lines cannot corrupt them.
- `Remove-BuiltCatzcRoot` restores the two root variables and deletes the build.
- `Set-GitTrackedPathMock` registers a Pester mock of `Get-GitTrackedPath` in `Catzc.Base.Languages`, which ends with the calling block.

## Functions

- `New-FakeRepositoryRoot` — create, populate, and activate a temp repository root; returns a handle for teardown.
- `New-ModuleFolder` — fabricate one `pwsh/<Name>/` module folder with public, private, and extra files.
- `Remove-FakeRepositoryRoot` — restore the root variables and delete the temp tree.
- `Set-GitTrackedPathMock` — mock `Get-GitTrackedPath` for the calling block.
- `New-BuiltCatzcRoot` — build selected modules into a temp folder for a build-mode test.
- `Invoke-InBuiltCatzc` — run a script block in a child `pwsh` that has entered build mode.
- `Remove-BuiltCatzcRoot` — restore the root variables and delete the build.

## Related

- ADR: [test-automation](../../../drs/automation/test-automation.md) — isolating logic tests behind seams, which these fixtures provide.
- ADR: [one-living-version](../../../drs/principles/one-living-version.md) and
  [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md) — why a multi-function `.internal` `.psm1` is sanctioned here.
- Reference: `Catzc.Internal.Loader` — `Import-InternalModule TestKit` loads it; the internal area overview.
