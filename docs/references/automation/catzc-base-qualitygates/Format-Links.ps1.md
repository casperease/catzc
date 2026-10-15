---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-Links.ps1.md
    kind: comment-page
    body_sha: "3c033f444927"
    adrs:
      - ADR-REPO-LINK#8
---

# automation/Catzc.Base.QualityGates/Format-Links.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The link aligner and the repository-wide migration in one command
([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)). Every ADR reference in a
comment of a code file becomes a canonical code link — `[ADR-<CODE>#<n>](/docs/adr/<path>.md#rule-adr-<code><n>)`,
or `[ADR-<CODE>](/docs/adr/<path>.md)` for a whole ADR — whatever spelling it had: a bare, ../, or rooted docs/adr
path, an ADR file name, a bare citation (`ADR-X`, `ADR-X:n`, `ADR-X#n`), a path followed by its citation, or a
link in another shape. The citation code is the source of truth, so a path to a moved ADR is re-pointed. In
markdown files a repository-rooted link becomes relative to its file, and a prose rule citation `ADR-X:n` becomes
`ADR-X#n`. In a code file's string literals a rule citation `ADR-X:n` becomes `ADR-X#n` too, and stays plain data
(only the ':' changes), except in a `### Rule` heading the string builds and in a file links.yml's
string_citations exempts. A string is data its code consumes, so align it together with whatever reads it.

A comment line that outgrows its line limit (.editorconfig max_line_length, with links.yml overrides) is wrapped
per -Wrap: broken before the link, never inside it, continuing with the same comment prefix and indent.

What cannot be fixed mechanically — a dangling path, an unknown citation code or rule, a bad anchor — is left as
written and listed as unfixable; Test-Links reports it. The engine is compiled C# (Catzc.Base.QualityGates.LinkEngine)
and runs files in parallel, so a whole-repository run is fast. Files are written as UTF-8 without a BOM, with
their own line endings kept. A source-tree tool: it throws in build mode (Assert-SourceTree).
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return a result object ({ ChangedCount, ChangedFiles, Fixed, Unfixable, DryRun, ElapsedMs }) instead of only the
changed paths.
```
