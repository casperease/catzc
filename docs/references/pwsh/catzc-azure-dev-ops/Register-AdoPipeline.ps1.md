# pwsh/Catzc.Azure.DevOps/Register-AdoPipeline.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Creates an Azure DevOps pipeline pointing to a YAML file.

### description

Uses the ADO Pipelines REST API to register a pipeline definition backed by a YAML file. Supports both Azure Repos Git and GitHub
repositories. Throws if a pipeline with the same name already exists. The pipeline definition is Azure DevOps configuration, an adjacent
store
([TDR-ONETRUTH-REPOSITORYISCONFIGURATIONRECORD](../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-repositoryisconfigurationrecord)),
driven one way from the YAML the repository holds and never edited beside the trunk.

Requires authentication via Get-AdoAuthorizationHeader (pipeline token, PAT or az login, in that order).

### parameter `Name`

Display name for the pipeline in Azure DevOps.

### parameter `YamlPath`

Repository-relative path to the YAML file (e.g. '.ado/pipelines/ci-pwsh.yaml').

### parameter `GitHubRepository`

Full GitHub repository URL (e.g. '<https://github.com/owner/repo>'). When set, the pipeline takes its source from GitHub instead of Azure
Repos Git. Requires a GitHub service connection in the ADO project.

### parameter `ConnectionId`

ID of the GitHub service connection in ADO. Required when using -GitHubRepository.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter `RepositoryName`

Name of the Azure Repos Git repository. Ignored when -GitHubRepository is set. Defaults to this checkout's repository
(Get-AdoRepositoryName).

### parameter `FolderPath`

Pipeline folder path in ADO. Defaults to root ('\').

### example 1

```powershell
Register-AdoPipeline 'CI' '.ado/pipelines/ci-pwsh.yaml'
```

### example 2

```powershell
Register-AdoPipeline 'CI' '.ado/pipelines/ci-pwsh.yaml' -GitHubRepository 'https://github.com/casperease/catzc' -ConnectionId $id
```

### example 3

```powershell
Register-AdoPipeline 'CI Expected Failures' '.ado/pipelines/ci-pwsh-expected-failures.yaml' -FolderPath '\CI'
```
