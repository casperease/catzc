# pwsh/Azure.Cli/tests/Get-AzCliSessionSubscription.Tests.ps1

The L0 tests of the function that maps the az session's active subscription to its declared `azure.yml` identity.

## Fixtures

The session read is a whole-function boundary mock
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)).
Config discovery redirects to the fixture identities, so nothing production is in play.
