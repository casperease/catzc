# docs/references/automation/catzc-azure-devops/Get-AdoRepositoryName.ps1.md

`automation/Catzc.Azure.DevOps/Get-AdoRepositoryName.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
In a pipeline, the agent's own repository ($env:BUILD_REPOSITORY_NAME); on a devbox, the checkout folder's
name (the leaf of Get-RepositoryRoot), which is the repository's name in a default clone. The one place the
ADO functions derive the name, declared as their -RepositoryName default
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)), so an
explicit argument always wins and Get-Help shows where the default comes from.
```
