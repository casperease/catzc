# pwsh/Azure.DevOps.BuildValidation/Register-AdoBranchPolicies.ps1

The command that converges the pull-request policies of the guarded branch to the `policies` section of `build-validation.yml`: the reviewer
minimum, the merge strategy, comment resolution and the automatic reviewers.

## help

### synopsis

Registers the pull-request branch policies declared under 'policies' in build-validation.yml. Idempotent.

### description

Reads the 'policies' section of build-validation.yml and, for each Azure DevOps policy type it maps to, creates the policy when the branch
has none, updates it when a setting drifted, and leaves it alone when it is current, then emits one result per policy. The minimum-reviewers
policy carries the reviewer minimum, whether the author's vote counts and whether a push resets approvals; the merge-strategy policy carries
the allowed merge types; the comment-requirements policy is present while comment resolution is required, and the required-reviewers policy
while the config names reviewer ids. Every policy is blocking and scoped to the branch in this repository. Sync-AdoBuildValidations calls it
when the git_workspace variant is main-via-pr.

### parameter `Branch`

The branch the policies guard. Defaults from build-validation.yml 'branch'.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL. Defaults to the value in ado.yml.

### parameter `RepositoryName`

Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).

### parameter `DryRun`

Return every policy's planned action (Create/Update/Unchanged) without touching the server.

### example 1

```powershell
Register-AdoBranchPolicies -DryRun
```
