---
catzc:
  immutable:
    with_body_sha: "5b821d9f79a8"
    path: docs/references/automation/catzc-base-modulesystem/New-Importer.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem
    name: new-importer-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CONSOLE#11
      - ADR-PWSH-ANNOUNCE#6
---

# automation/Catzc.Base.ModuleSystem/New-Importer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$parseErrors = $null`, written with `#`.

```text
Read the overlay's parameter block from source (the overlay is not loaded post-import). Each parameter
becomes one clean `[type] $Name` line; the overlay keeps its own per-parameter doc comments.
```

## comment:2

Above `$suppression =...`, written with `#`.

```text
The shim sets $env:RepositoryRoot, but its announcement is delegated
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)):
Invoke-Importer
names it on its Roots line, the first point a writer is loaded.
```

## comment:3

Above ``$paramBlock = "$suppression`n" + "[CmdletBinding()]`n" + "param(`n" +...``, written with `#`.

```text
[CmdletBinding()] makes the shim accept -Verbose (forwarded to Invoke-Importer by @PSBoundParameters), which
shows the importer's own state-change record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)).
Dot-sourced, the preference stays inside
the import and does not leak into the caller's session.
```

## comment:4

Above `$explanation = @'`, written with `#`.

```text
Fixed template around the generated param block. Single-quoted here-strings keep $env:/$PSScriptRoot/
@PSBoundParameters literal. The one living copy of the shim body lives here; importer.ps1 is generated.
```

## comment:5

Above ``$content = $explanation + "`n" + $paramBlock + "`n`n" + $body + "`n"``, written with `#`.

```text
LF throughout, one trailing newline. The explanation/param/body join and the EOF newline match the committed
importer.ps1 below its generated-file head byte-for-byte (the drift test compares EOL-insensitively).
```
