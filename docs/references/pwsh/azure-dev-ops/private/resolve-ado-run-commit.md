# pwsh/Azure.DevOps/private/Resolve-AdoRunCommit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$run = & $GetRun $RunId`, written with `#`.

```text
A DEPLOY run deploys the commit of the CI run it names
([FDR-TYPE-DEPLOYISPINNED](/docs/drs/flow/pipeline-types.md#rule-fdr-type-deployispinned)); any other run its own
source commit.
```
