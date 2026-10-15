# docs/references/automation/catzc-base-asserts/Assert-LastExitCodeWasZero.ps1.md

`automation/Catzc.Base.Asserts/Assert-LastExitCodeWasZero.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Checks the global $LASTEXITCODE variable and throws if it is non-zero.
Resets $LASTEXITCODE after checking unless -DoNotReset is specified.
```
