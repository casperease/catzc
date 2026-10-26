# pwsh/Azure.Templates/tests/Get-BicepSubscriptionConfigViolations.Tests.ps1

The L0 tests of the private subscription-resolution violations rule.

## Fixtures

The fixture `azure` holds a non-customer pair (the shared platform), a customer pair (`acme`), and a second rogue non-customer subscription
that overlaps `core_lower` on `beta`, the root-ambiguity case.

The customer catalogue reads are whole-boundary mocks
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)).
The rule needs the key list, and the candidates rule normalizes a non-matching raw token through `Get-AzureCustomer`.
