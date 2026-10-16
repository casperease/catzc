---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Import-AllModules.Tests.ps1.md
    folder: docs/references/automation/internal/tests
    name: import-all-modules-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "04d9bb4ffa57"
    adrs:
      - ADR-AUTO-CONSOLE#11
      - ADR-AUTO-TEST#26
---

# automation/.internal/tests/Import-AllModules.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$sandbox = Join-Path ([System.IO.Path]::GetTempPath())...`, written with `#`.

```text
Build an isolated sandbox = importer + the .internal shared modules (loader, bootstrap, …) + vendor, with
NO application modules. Each test populates it and runs the importer in a fresh child pwsh process (a cold,
fully-isolated re-derive of module state from the current files). The importer is a pure function of the
filesystem, so we only need ONE import per distinct tree shape — each test below captures everything it
needs from a single import, then asserts the facets in separate It blocks.
```

## comment:2

Above `Copy-Directory (Join-Path $env:RepositoryRoot 'automation/.internal')...`, written with `#`.

```text
Copy-Directory (raw [System.IO]) instead of Copy-Item -Recurse: .vendor (Pester + powershell-yaml, ~88
files) copies in ~190ms vs ~1.25s with the cmdlet.
```

## comment:3

Above `$script:moduleListExpr =`, written with `#`.

```text
Expression (run inside the child) that lists the loaded application modules and their exported functions.
Bootstrap and the vendored modules are filtered out; $_ is escaped so it evaluates in the child.
```

## comment:4

Above `param([Parameter(Mandatory)][string]$Capture)`, written with `#`.

```text
ONE cold import in a child pwsh; $Capture is evaluated AFTER the import and returned as parsed JSON. The
import's announcements are information records
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)), so
6>$null keeps them out of the JSON.
```

## comment:5

Above `BeforeAll {` (occurrence 2), written with `#`.

```text
One import of a rich tree covers discovery, public export, the public/private boundary, a private
being callable from a public function, multiple independent modules, and the collision guard NOT
falsely-giving-positives on a private name shared across modules (the import simply succeeds).
```

## comment:6

Above `($modules | Where-Object { $_.Name -eq 'PrivA' }).Exported | Should -Contain...`, written with `#`.

```text
The import above succeeded with PrivA and PrivB each defining a private Get-Shared; both modules
loaded and neither exports it — proving the collision guard ignores module-scoped privates.
```

## comment:7

Above `BeforeAll {` (occurrence 3), written with `#`.

```text
Mutate the populated tree every way an author can, then re-import: one cold import must reflect a
changed body, an added function, a deleted function, and a deleted module.
```

## comment:8

Above `Describe 'Run-mode eviction across code roots' -Tag 'L2', 'logic', 'greedy' {`, written with `#`.

```text
Greedy: one child pwsh dot-sources three importers in sequence (process-global module state), so it consumes the
machine beyond its own process and carries an L2-scale budget
([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)).
```

## comment:9

Above `function New-EvictionRoot {`, written with `#`.

```text
Two complete sandbox roots (importer + .internal + .vendor) — stand-ins for a source tree and a build.
Each holds a module only it ships and a same-named module that reports which root it came from.
```
