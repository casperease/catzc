---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Links.ps1.md
    kind: comment-page
    body_sha: e0330aba5fca
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-LINK#5
---

# automation/Catzc.Base.QualityGates/Test-Links.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs the same engine as Format-Links, read-only, and reports every violation: a code link not yet in canonical
repository-rooted form, a markdown link that is rooted or climbs above the repository root, a rule citation
spelled `ADR-X:n` in prose, a comment, or a code string literal, a link target or #fragment that does not exist,
an unknown citation code or rule, an absolute URL into this repository outside .github/, and a docs path in a
PowerShell string that names no file. A fixable violation is fixed by running Format-Links, and its issue says so;
the rest need a person. Informational findings (a comment line that stays over its limit) are counted but never
fail the gate.

The string-citation check (`ADR-X:n` in a string literal,
[ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)) takes its mode and exempt globs
from links.yml's string_citations: in gate mode its findings are issues; in report mode they are printed as its
work list and counted (ReportedCount), and never fail the gate.

A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
through Write-QualityGateReport, which writes out/test-links/, prints every issue, and throws once listing them
all. Each issue reads '<file>:<line>:<column> [<type>] <message>'. It needs the source tree: it throws in build mode.
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, FixableCount, InformationCount,
ReportedCount, Reported }) instead of throwing.
```
