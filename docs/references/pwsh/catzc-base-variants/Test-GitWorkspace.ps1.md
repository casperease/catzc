# pwsh/Catzc.Base.Variants/Test-GitWorkspace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether the repo's git workspace mode (the `git_workspace` variant) is the one named.

### description

A predicate over the `git_workspace` repo-wide variant (see Get-GitWorkspace). Pass exactly one of -MainDirect or -MainViaPr; returns $true
when the repo's mode matches. The canonical consumer shape is the stop condition for automated commits:
`(Test-GitWorkspace -MainViaPr) -and <on main locally>` — in main-via-pr mode local work always happens on a branch, so standing on main is
the only place a direct commit is forbidden.

### parameter `MainDirect`

Test for the 'main-direct' mode (solo-author trunk; direct commits to main allowed).

### parameter `MainViaPr`

Test for the 'main-via-pr' mode (changes reach main only through a PR).

### example 1

```powershell
if ((Test-GitWorkspace -MainViaPr) -and $branch -in 'main', 'master') { return }
```
