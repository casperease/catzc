---
catzc:
  immutable:
    with_body_sha: cdfb0a2d31e2
    path: docs/references/automation/catzc-base-writers/private/Write-InformationColored.ps1.md
    folder: docs/references/automation/catzc-base-writers/private
    name: write-information-colored-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Writers/private/Write-InformationColored.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly...`, written with `#`.

```text
Suppress during Pester runs (flag set by Test-Automation). The single chokepoint for all writers,
so nothing routed through here can leak into test output. See .DESCRIPTION for why a flag, not a stream.
Read through Get-Variable: the flag is unset outside a test run, and strict mode rejects an unset variable.
```

## comment:2

Above `$ansi = [Catzc.Base.Writers.Ansi]::Code($ForegroundColor)`, written with `#`.

```text
The ConsoleColor -> ANSI SGR map lives once, in the Ansi type (shared with the rainbow writer),
so this chokepoint and RainbowColor can never disagree on a colour's code. Empty = no escape.
```
