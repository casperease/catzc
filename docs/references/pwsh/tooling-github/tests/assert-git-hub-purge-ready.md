# pwsh/Tooling.Github/tests/Assert-GitHubPurgeReady.Tests.ps1

The L0 tests of `Assert-GitHubPurgeReady`. Every external call goes through a mocked `Invoke-Executable`, so each precondition is proved to
throw its own error without launching gh or git.

## Mocks

A catch-all mock comes first, so a command no later mock answers fails the test instead of launching. A mock body runs in the module's
session state and cannot reference a test-scope helper, so each result object is written inline.
