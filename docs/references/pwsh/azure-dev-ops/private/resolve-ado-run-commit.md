# pwsh/Azure.DevOps/private/Resolve-AdoRunCommit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Names the source commit a pipeline run stands for.

### description

Reads the run through the given script block. A run that carries a `CiRunId` template parameter is a deploy run, and the commit is that CI
run's source version; any other run answers its own source version. Private helper of Update-AdoFlowOccupants; not exported.

### parameter `RunId`

The id of the run to resolve.

### parameter `GetRun`

A script block that takes a run id and returns the build record, so the caller can cache the reads.

### outputs

`[string]` The commit sha.

### example 1

```powershell
Resolve-AdoRunCommit -RunId '1234' -GetRun { param($id) Invoke-AdoRestMethod -Uri "$base/build/builds/${id}?api-version=7.1" }
```

## comment:1

Above `$run = & $GetRun $RunId`, written with `#`.

```text
A DEPLOY run deploys the commit of the CI run it names
([FDR-TYPE-DEPLOYISPINNED](/docs/drs/flow/pipeline-types.md#rule-fdr-type-deployispinned)); any other run its own
source commit.
```
