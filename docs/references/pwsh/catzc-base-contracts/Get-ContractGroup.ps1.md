# pwsh/Base.Contracts/Get-ContractGroup.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$found = @(Get-CatzcModule -Name $Module -RepositoryRoot $RepositoryRoot)`, written with `#`.

```text
The group names where the module lives, never the namespace it carries; the contracts config holds the form and
its exceptions (pwsh.base.vs_code for Catzc.Base.VSCode).
```
