---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FormatEngineStamp.ps1.md
    kind: reference
    body_sha: "9b6aaf814d26"
    adrs:
      - ADR-AUTO-CACHE#10
---

# automation/Catzc.Base.QualityGates/private/Get-FormatEngineStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Format-Code's result cache keys a file on its SHA-256 and this stamp (Get-ContentStamp): the engine's name and each
settings file languages.yml lists for the engine — including the tool registry whose pin names the engine's version,
so a new pin is a new stamp ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). No input
is known here that languages.yml does not declare.
```
