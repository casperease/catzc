---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/private/Write-InformationColored.ps1.md
    kind: comment-page
    body_sha: d702d2160b0d
---

# automation/Catzc.Base.Writers/private/Write-InformationColored.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly...`.

```text
Suppress during Pester runs (flag set by Test-Automation). The single chokepoint for all writers,
so nothing routed through here can leak into test output. See .DESCRIPTION for why a flag, not a stream.
Read through Get-Variable: the flag is unset outside a test run, and strict mode rejects an unset variable.
```

## comment:5

Above `$ansi = [Catzc.Base.Writers.Ansi]::Code($ForegroundColor)`.

```text
The ConsoleColor -> ANSI SGR map lives once, in the Ansi type (shared with the rainbow writer),
so this chokepoint and RainbowColor can never disagree on a colour's code. Empty = no escape.
```
