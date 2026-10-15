# docs/references/automation/catzc-base-qualitygates/private/Get-ResultCache.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-ResultCache.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A per-machine file under out/cache/ (gitignored, never committed): repository-relative '/'-separated path ->
'<file SHA-256>:<stamp>' (Get-ContentStamp over every input that decides the check's verdict), recorded when the
check last found the file clean ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). A file
whose bytes or the check's inputs changed no longer matches its entry and is checked again. A missing or unreadable
cache is an empty one, so the only cost of losing it is one full check; a pipeline starts with none. Format-Code
and Get-ScriptAnalyzerDiagnostics keep one each.
```
