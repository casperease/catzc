---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/New-Importer.ps1.md
    kind: reference
    body_sha: a803acc8b656
    adrs:
      - ADR-AUTO-CONSOLE#11
      - ADR-PWSH-ANNOUNCE#6
---

# automation/Catzc.Base.ModuleSystem/New-Importer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
importer.ps1 is a thin, generated entry point: it carries the importer's public parameter form and
delegates the whole load sequence to Invoke-Importer (automation/.internal/Catzc.Internal.Importer.psm1),
the single living copy. This reads the overlay's parameter block straight from that module's source (an AST
parse — the overlay is not loaded post-import) and renders the shim around a fixed template, so the shim's
parameters can never drift from the overlay's. A drift test asserts the committed importer.ps1 equals this
output.

Scaffolds into ANY repository root that already carries the .internal overlay — the loader path in the shim
is repository-root-relative, so nothing absolute is baked in.

Writes the source tree's entry point from the source overlay, so it stops with a named error in build mode
(Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
```

## comment:2

Above `$parseErrors = $null`.

```text
Read the overlay's parameter block from source (the overlay is not loaded post-import). Each parameter
becomes one clean `[type] $Name` line; the overlay keeps its own per-parameter doc comments.
```

## comment:3

Above `$suppression =...`.

```text
The shim sets $env:RepositoryRoot, but its announcement is delegated
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)):
Invoke-Importer
names it on its Roots line, the first point a writer is loaded.
```

## comment:4

Above ``$paramBlock = "$suppression`n" + "[CmdletBinding()]`n" + "param(`n" +...``.

```text
[CmdletBinding()] makes the shim accept -Verbose (forwarded to Invoke-Importer by @PSBoundParameters), which
shows the importer's own state-change record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)).
Dot-sourced, the preference stays inside
the import and does not leak into the caller's session.
```

## comment:5

Above `$header = @'`.

```text
Fixed template around the generated param block. Single-quoted here-strings keep $env:/$PSScriptRoot/
@PSBoundParameters literal. The one living copy of the shim body lives here; importer.ps1 is generated.
```

## comment:6

Above ``$content = $header + "`n" + $paramBlock + "`n`n" + $body + "`n"``.

```text
LF throughout, one trailing newline. The header/param/body join and the EOF newline match the committed
importer.ps1 byte-for-byte (the drift test compares EOL-insensitively).
```
