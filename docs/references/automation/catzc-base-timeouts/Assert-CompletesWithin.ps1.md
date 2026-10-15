# docs/references/automation/catzc-base-timeouts/Assert-CompletesWithin.ps1.md

`automation/Catzc.Base.Timeouts/Assert-CompletesWithin.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The assertion form of Invoke-WithTimeout: the block's output is discarded, and the only outcome is pass
(it finished in time) or throw (it was stopped at the limit, or it failed on its own).
```

## comment:2

Section `.PARAMETER Budget` of the comment-based help.

```text
The work's immutable budget GUID. While timeout-exemptions.yml exempts it, the default limit is the exemption
ceiling instead.
```

## comment:3

Section `.PARAMETER Seconds` of the comment-based help.

```text
The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption
ceiling (Get-TimeoutSeconds -Budget).
```
