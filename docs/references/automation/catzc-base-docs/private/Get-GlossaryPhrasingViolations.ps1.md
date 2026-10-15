# docs/references/automation/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md

`automation/Catzc.Base.Docs/private/Get-GlossaryPhrasingViolations.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
An avoided phrasing blurs a defined term, so prose within its source's scope never uses it
([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)). For every source whose
`checks` include `avoid`,
this reads the tracked files its `scope` matches and its `exclude` does not
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)), on the text
surfaces its `surfaces` name:
  - markdown — the prose of `*.md` files: fenced code blocks are skipped;
  - comments — PowerShell comments that are not comment-based help;
  - help — comment-based help (a block comment holding .SYNOPSIS or .DESCRIPTION);
  - messages — the static text of the strings passed to `throw`, `Write-Message`, `Write-Warning`,
    `Write-Error`, and `Write-Host`, and of any `-ErrorText` or `-Because` value; an expandable string
    contributes its literal text only.
PowerShell files (`*.ps1`, `*.psm1`) are read through the parser, never by regex. A phrase matches
case-insensitively, as whole words, with any whitespace between its words (so a wrapped line still counts).
A mention — the phrase inside backticks, "double" or “curly” quotes, within one paragraph — is exempt, so the
vocabulary can talk about itself. Globs are the repository's one glob dialect (Catzc.Base.Globs.GlobPattern).

Private helper for the glossary checks; not exported.
```

## comment:2

Section `.PARAMETER SurfaceCache` of the comment-based help.

```text
The text surfaces already read, keyed by tracked file, each value the file's Catzc.Base.Docs.GlossarySegment array
(Catzc.Base.Docs.GlossaryProse): a file read once is not read again. Test-Glossary hands the
same table to this check and to the forms check (G6, Get-GlossaryFormViolations), which read the same surfaces of
the same files under the same root, so one run reads each file's prose once. Defaults to an empty table.
```

## comment:3

Above `[string[]]...`.

```text
The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into the
surface cache once, and matches every avoided phrasing over the files each glossary source's scope selects.
```
