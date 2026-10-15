# docs/references/automation/catzc-azure-devops/Write-AdoEnvironmentDiagnostic.ps1.md

`automation/Catzc.Azure.DevOps/Write-AdoEnvironmentDiagnostic.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the whitelist from configs/pipeline-env.yml and displays
only those environment variables. Variables that are not set are shown
as empty. Designed for the top of every Invoke-AdoScript run so
operators see build context, paths, and agent info at a glance.
```
