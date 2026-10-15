# docs/references/automation/catzc-base-qualitygates/Format-Types.ps1.md

`automation/Catzc.Base.QualityGates/Format-Types.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every automation C# type lives at automation/<Module>/types/<Type>.cs and belongs to namespace <Module>
(ADR native-csharp-types). The namespace is NOT hand-authored: this formatter writes/repairs the
`namespace <Module>;` line from the file's folder, so the folder stays the single source of truth and a
move between modules is a safe refactor — re-running Format-Types rewrites the line to the new folder, and
Test-Formatting (its -DryRun) fails CI on any drift. The declared namespace is what lets the editor's C#
toolchain compile and analyze these files (no CA1050), so the rule is visible in-editor (everything-as-code).

For each types/*.cs: the line is inserted after the leading comment/using block (before the first type or
attribute) when absent, corrected when it names the wrong module, and left untouched when already correct.
Files are written back as UTF-8 without a BOM with LF line endings (repo convention). Logic is never
changed — only the namespace line. A block-scoped `namespace X { … }` is the one shape it cannot fix: it is
left untouched and reported in BlockScopedFiles (Test-Formatting turns each into an issue).

A source-tree tool: it rewrites the repository's type sources, so it throws in build mode
(Assert-SourceTree).
```

## comment:2

Above `if ($original -notmatch '(?m)^\s*namespace\s+\S+?\s*;' -and $original -match...`.

```text
A block-scoped `namespace X { … }` is not a shape this repo authors, and rewriting it is not a one-line
fix: report it for a hand edit instead.
```
