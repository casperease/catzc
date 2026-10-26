# pwsh/Base.ModuleSystem/New-Importer.ps1

Generates a repository's `importer.ps1`, a thin shim that carries the importer's public parameter form and delegates the load sequence to
`Invoke-Importer`. It renders the shim from the overlay's own parameter block, so the two cannot drift.

## help

### synopsis

(Re)generates a repository's importer.ps1 shim from the Invoke-Importer overlay.

### description

importer.ps1 is a thin, generated entry point: it carries the importer's public parameter form and delegates the whole load sequence to
Invoke-Importer (pwsh/.internal/Catzc.Internal.Importer.psm1), the single living copy. This reads the overlay's parameter block straight
from that module's source (an AST parse — the overlay is not loaded post-import) and renders the shim around a fixed template, so the shim's
parameters can never drift from the overlay's. A drift test asserts the committed importer.ps1 equals this output.

Scaffolds into ANY repository root that already carries the .internal overlay — the loader path in the shim is repository-root-relative, so
nothing absolute is baked in.

Writes the source tree's entry point from the source overlay, so it stops with a named error in build mode (Assert-SourceTree,
[DDR-RUNMODE](../../../drs/design/run-modes.md)).

### parameter `RepositoryRoot`

The repository root to generate importer.ps1 into (and whose overlay is read). Defaults to this repository.

### parameter `Force`

Overwrite an existing importer.ps1. Without it, an existing importer.ps1 is left untouched (throws).

### parameter `DryRun`

Return the generated shim content as a string without writing anything.

### outputs

`[string]` The generated content (-DryRun), otherwise the written importer.ps1 path.

### example 1

```powershell
New-Importer -Force
```

### example 2

```powershell
New-Importer -RepositoryRoot ./some/other/repo
```

## Parameter block

The overlay's parameter block is read from source, since the overlay is not loaded after the import. Each parameter becomes one clean
`[type] $Name` line, and the overlay keeps its own per-parameter doc comments. The block opens with `[CmdletBinding()]`, so the shim accepts
`-Verbose` and forwards it to `Invoke-Importer` through `@PSBoundParameters`, which shows the importer's own state-change record
([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](../../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)).
The shim is dot-sourced, so the preference stays inside the import and does not leak into the caller's session.

## Template

The template around the generated block is fixed. Its single-quoted here-strings keep `$env:`, `$PSScriptRoot` and `@PSBoundParameters`
literal, and it is the one living copy of the shim body, because `importer.ps1` is generated. The shim sets `$env:RepositoryRoot`, but the
announcement is delegated
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)):
`Invoke-Importer` names it on its Roots line, the first point a writer is loaded. The modules folder is read back through the resolver, so
this generator names no folder of its own and the shim spells the folder from the same place.

## Line endings

The output uses LF throughout and one trailing newline. The explanation, parameter block and body join, and the end-of-file newline, match the
committed `importer.ps1` below its generated-file head byte for byte. The drift test compares them insensitive to line endings.
