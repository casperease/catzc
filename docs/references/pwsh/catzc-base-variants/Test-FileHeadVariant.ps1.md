# pwsh/Catzc.Base.Variants/Test-FileHeadVariant.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether the repo's file-heads mode for code (the `file_heads.code` variant) is the one named.

### description

A predicate over the `file_heads.code` repo-wide variant (see Get-FileHeadVariant). Pass exactly one of -Minimal or -None; returns $true
when the repo's mode matches. The file-meta head policy asks it whether an authored code or config file carries the navigation head.

### parameter `Minimal`

Test for the 'minimal' mode (an authored code or config file carries the navigation head).

### parameter `None`

Test for the 'none' mode (no authored file carries a head).

### outputs

`[bool]` Whether the mode matches.

### example 1

```powershell
if (Test-FileHeadVariant -None) { return }
```
