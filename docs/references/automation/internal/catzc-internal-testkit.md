# Catzc.Internal.TestKit

An on-demand Pester fixture library. Many tests stand up a synthetic repository on disk — a temp root, an `automation/<module>` tree, and
`$env:RepositoryRoot` pointed at it (restored afterward) — and this module centralizes that boilerplate. Unlike the other `.internal` shared
modules it is **not loaded by the importer at startup**: a test loads it on demand through `Import-InternalModule TestKit` in `BeforeAll`,
and it stays for the session. Being a `.internal` shared module (dot-prefixed), the module conventions — one-function-per-file and
Verb-Noun-only exports — do not apply to it: it is a deliberate multi-function fixture helper.

## What it does

The fixtures fabricate a throwaway repository so a test can exercise discovery, manifest generation, or anything that anchors on
`$env:RepositoryRoot` without touching the real tree:

- `New-FakeRepositoryRoot` creates a fresh temp repository root, populates it from a `-Modules` map (each entry a module name and an
  optional spec of public/private function names and extra files) and a `-Files` map (repo-root-relative paths and content — `importer.ps1`,
  `.editorconfig`, …), points `$env:RepositoryRoot` at it, and returns a handle `{ Root; Automation; Saved }`.
- `New-ModuleFolder` fabricates one module folder under a root: `automation/<Name>/` with public function files at the module root,
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
- `New-ModuleFolder` — fabricate one `automation/<Name>/` module folder with public, private, and extra files.
- `Remove-FakeRepositoryRoot` — restore `$env:RepositoryRoot` and delete the temp tree.

## Related

- ADR: [test-automation](../../../adr/automation/test-automation.md) — isolating logic tests behind seams, which these fixtures provide.
- ADR: [one-living-version](../../../adr/principles/one-living-version.md) and
  [use-ps1-not-psm1](../../../adr/automation/powershell/use-ps1-not-psm1.md) — why a multi-function `.internal` `.psm1` is sanctioned here.
- Reference: [Catzc.Internal.Loader](catzc-internal-loader.md) — `Import-InternalModule TestKit` loads it; the
  [internal area overview](index.md).
