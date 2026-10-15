---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ContentStamp.ps1.md
    kind: comment-page
    body_sha: f2032f4bf81f
    adrs:
      - ADR-AUTO-CACHE#10
---

# automation/Catzc.Base.QualityGates/private/Get-ContentStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality check's result cache keys each file on its own SHA-256 and this stamp of everything else that decides
the check's verdict ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). A missing input
hashes as missing, so adding, editing or removing one changes the stamp, and every cached verdict of that check is
checked again. The files are fingerprinted in the given order under their repository-relative paths, so the stamp
is the same on every clone.

A PowerShell input (.ps1, .psm1, .psd1 — an analyzer rule, a settings file) is fingerprinted by its tokens without
its comments: a comment never decides a verdict, and comments in rule files change often (an ADR citation sweep
rewrites them), which would otherwise send every file back through the check. Every change to the code itself
still changes the stamp. A PowerShell file that does not parse, and every other input, is fingerprinted by its
bytes.
```

## comment:2

Above `$previousWasLineEnd = $true`.

```text
Comments go; a run of line ends (what a removed comment line leaves) counts as one, since a line
end separates statements but a blank line does not.
```

## comment:3

Above `$previousWasLineEnd = $true`.

```text
Comments go; a run of line ends (what a removed comment line leaves) counts as one, since a line
end separates statements but a blank line does not.
```
