# pwsh/Azure.Templates/tests/Get-BicepDeploymentName.Tests.ps1

The L0 tests of the deployment-name function.

## Choosing the platform

`Get-BicepDeploymentName` picks the platform by which run-id data variable is present: `GITHUB_RUN_ID` means GitHub Actions, otherwise
Azure DevOps. Each case sets its own variables and clears the other's run id. That matters because these tests themselves run on a GitHub
Actions runner, where `$env:GITHUB_RUN_ID` is already set.
