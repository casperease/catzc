# automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Creates an Azure DevOps pull request via the Git REST API.

### description

The "land via PR" half of an INPUT pipeline (see [ADR-FLOW-CD-TYPE](../../../adr/flow/pipeline-types.md)): once an INPUT step has committed
a config change to a branch, this opens a PR so the change goes through the normal PR gate before the CD pipeline deploys it.

Resolves the repository by name, normalizes branch names to `refs/heads/<branch>`, and POSTs the PR. Authentication is the dual-auth pattern
via Invoke-AdoRestMethod / Get-AdoAuthorizationHeader (pipeline SYSTEM_ACCESSTOKEN, PAT, or az login).

### parameter `Title`

PR title.

### parameter `SourceBranch`

The branch with the change (e.g. 'input/discovery-dev-1234'). Accepts a bare branch name or a full 'refs/heads/...' ref.

### parameter `TargetBranch`

The branch to merge into. Defaults to 'main'. Bare name or full ref.

### parameter `Description`

Optional PR description.

### parameter `RepositoryName`

Azure Repos Git repository name. Defaults to this checkout's repository (Get-AdoRepositoryName).

### parameter `Project`

Azure DevOps project. Defaults to ado.yml.

### parameter `Organization`

Azure DevOps organization URL. Defaults to ado.yml.

### example 1

```powershell
New-AdoPullRequest -Title 'input: discovery/dev' -SourceBranch 'input/discovery-dev-1234'
```

### example 2

```powershell
New-AdoPullRequest 'input: apex prod' 'input/apex-prod-99' -TargetBranch main -Description 'From ITSM #4821'
```

## comment:1

Above `Assert-NotNull $pr.pullRequestId -ErrorText "Pull request creation returned...`, written with `#`.

```text
Postcondition: confirm the PR actually came back created. A non-throwing response with no id means the
create did not take effect — fail fast here rather than return a phantom result downstream.
```
