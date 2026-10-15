---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FormatEngineStamp.ps1.md
    kind: comment-page
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
settings entry languages.yml lists for the engine. An entry is a whole file, or `<file>#<key>` for one top-level key
of a YAML file; the tool registry is listed by the keys of the tools the engine runs, so that tool's new pin is a new
stamp and another tool's pin edit is not
([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). A missing file or key hashes as
missing, so adding or removing an input changes the stamp. No input is known here that languages.yml does not
declare.
```
