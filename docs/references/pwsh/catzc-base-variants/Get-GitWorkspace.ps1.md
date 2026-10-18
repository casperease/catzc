# pwsh/Catzc.Base.Variants/Get-GitWorkspace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the repo's git workspace mode ('main-direct' or 'main-via-pr').

### description

The `git_workspace` repo-wide variant (configs/variants.yml), fixed for the importer session: how changes reach main. 'main-direct'
(VariantsConfig's DefaultGitWorkspace) is the solo-author trunk — direct commits to main are allowed, including automation's own
(Sync-GeneratedFile). 'main-via-pr' means everything reaches main through a PR: local work always happens on a branch, so committing is
still always allowed there — the single stop condition is a direct commit made while standing on main locally (Test-GitWorkspace guards it).
Flip to 'main-via-pr' when the repo goes from one author to more.

### example 1

```powershell
Get-GitWorkspace   # -> 'main-direct'
```
