# pwsh/Azure.DevOps/tests/New-AdoPullRequest.Tests.ps1

The L0 tests of the command that creates an Azure DevOps pull request.

## The REST mock

The tests mock the REST boundary: the repository lookup returns one repository and the pull request POST returns a pull request object.
The mock matches `pullrequests` first, because the pull request URL also contains `git/repositories/<id>/`.
