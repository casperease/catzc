---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Export-Comments.ps1.md
    kind: comment-page
    body_sha: "2706e1accd4b"
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
    links: []
---

# automation/Catzc.Base.QualityGates/Export-Comments.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A file keeps one residue per long comment — an insight line, then a line with the comment's ADR citations and the
docs link `[comment:N](/<page>#commentN)` — and the prose moves verbatim into the file's comment page under
docs/references, so each has exactly one living copy
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). Nothing is dropped:
Build-CommentView puts every section back where its residue stands, and the engine's round-trip test proves the
view equals the original.

What moves is configured in comments.yml
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)): the file languages in
scope, the minimum prose lines, the comment heads each language keeps (`.SYNOPSIS`, `.EXAMPLE`, `#Requires`, …),
and where each folder's pages live. The scope is Get-CommentScope's: tracked files of those languages outside
tests/, minus vendored, generated, fixture and contract files.

A page that exists already keeps its sections as written; new comments are appended after its highest number, and
a number is never reused. A second run over an exported file changes nothing. The insight line is provisional —
the comment's first sentence, links and citations removed, cut to the file's line limit — and is meant to be
rewritten to say what the code does not. Source files keep their own line endings; pages are written canonical.
A source-tree tool: it throws in build mode (Assert-SourceTree).
```
