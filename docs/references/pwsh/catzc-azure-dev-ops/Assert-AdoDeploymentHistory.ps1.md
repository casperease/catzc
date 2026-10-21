# pwsh/Catzc.Azure.DevOps/Assert-AdoDeploymentHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Throws unless an Azure DevOps environment's deployment history holds a successful deployment of a CI run's commit.

### description

The certifying record of a rung is the deployment history of its environment
([FDR-CD-CERTIFYINGRECORD](../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-certifyingrecord)): a DEPLOY run to a
prod target calls this before it deploys, so a commit that never stood on pre-prod cannot ship. The commit is the source commit of the CI
run that built the artifact. Each successful deployment in the history names the run that made it; that run's commit is the source commit of
the CI run its `CiRunId` parameter names, or its own source commit when it has none. The newest matching deployment is returned; no match
throws, naming the commit and the environment.

### parameter `Environment`

The Azure DevOps environment whose history certifies the commit, e.g. `<unit>-pre-prod`.

### parameter `CiRunId`

The run id of the CI run that built the artifact being deployed.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL (`https://dev.azure.com/<org>`). Defaults to the value in ado.yml.

### parameter `Top`

How many of the newest deployments to read from the history.

### outputs

`[pscustomobject]` The certifying deployment: { Environment; Commit; RunId }.

### example 1

```powershell
Assert-AdoDeploymentHistory -Environment widget-pre-prod -CiRunId 1234
```
