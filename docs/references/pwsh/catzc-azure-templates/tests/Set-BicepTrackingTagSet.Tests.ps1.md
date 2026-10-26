# pwsh/Azure.Templates/tests/Set-BicepTrackingTagSet.Tests.ps1

The L0 tests of the command that writes the deployment-provenance tags.

## The scope

The scope subscription is the az session's, so `Get-AzCliSessionSubscription` is a whole-boundary session mock
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)).
