# pwsh/Azure.Templates/tests/Deploy-AzureResourceGroup.Tests.ps1

<!-- cspell:ignore nproperties -->

The L0 tests of the command that ensures a resource group exists.

## The caller resolves

The caller resolves the subscription and the region and passes them in. The function never re-resolves them from `azure.yml`, so the
resource group always lands in the deployment's subscription.
