# pwsh/Base.Variants/Get-GitWorkspace.ps1

The reader of the `git_workspace` variant: whether work lands on main directly or through a pull request, which the topic commands
`Save-Topic` and `Push-Topic` branch on.

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
