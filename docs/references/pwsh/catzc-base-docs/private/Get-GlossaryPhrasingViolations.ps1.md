# pwsh/Catzc.Base.Docs/private/Get-GlossaryPhrasingViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the uses of avoided phrasings within each glossary source's scope (check G4) — one message per use.

### description

An avoided phrasing blurs a defined term, so prose within its source's scope never uses it
([ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](../../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced)). For every source whose `checks` include
`avoid`, this reads the tracked files its `scope` matches and its `exclude` does not
([ADR-REPO-VOCAB-GLOSSARYSOURCE](../../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)), on the text surfaces its `surfaces` name:

- markdown — the prose of `*.md` files: fenced code blocks are skipped;
- comments — PowerShell comments that are not comment-based help;
- help — comment-based help (a block comment holding .SYNOPSIS or .DESCRIPTION);
- messages — the static text of the strings passed to `throw`, `Write-Message`, `Write-Warning`, `Write-Error`, and `Write-Host`, and of any
  `-ErrorText` or `-Because` value; an expandable string contributes its literal text only.

PowerShell files (`*.ps1`, `*.psm1`) are read through the parser, never by regex. A phrase matches case-insensitively, as whole words, with
any whitespace between its words (so a wrapped line still counts). A mention — the phrase inside backticks, "double" or “curly” quotes,
within one paragraph — is exempt, so the vocabulary can talk about itself. Globs are the repository's one glob dialect
(Catzc.Base.Globs.GlobPattern).

Private helper for the glossary checks; not exported.

### parameter `Entry`

The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.

### parameter `TrackedFile`

The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.

### parameter `Root`

The directory the tracked files are relative to. Defaults to the repository root.

### parameter `SurfaceCache`

The text surfaces already read, keyed by tracked file, each value the file's Catzc.Base.Docs.GlossarySegment array
(Catzc.Base.Docs.GlossaryProse): a file read once is not read again. Test-Glossary hands the same table to this check and to the forms check
(G6, Get-GlossaryFormViolations), which read the same surfaces of the same files under the same root, so one run reads each file's prose
once. Defaults to an empty table.

### outputs

`[string[]]` One message per use — `<file>:<line> says "<phrase>" — say "<say>" (<defined_by>)` — in file then line order; empty when prose
avoids every avoided phrasing.

### example 1

```powershell
Get-GlossaryPhrasingViolations
```

## comment:1

Above `[string[]]...`, written with `#`.

```text
The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into the
surface cache once, and matches every avoided phrasing over the files each glossary source's scope selects.
```
