# automation/Catzc.Azure.Templates/tests/Get-BicepSubscriptionConfigViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:azure = [ordered]@{`, written with `#`.

```text
Fixture azure: a non-customer pair (the shared platform) + a customer pair (acme) + a second
rogue non-customer subscription that overlaps core_lower on beta (the root-ambiguity case).
```

## comment:2

Above `Mock Get-AzureCustomers { @('acme', 'globex') } -ModuleName...`, written with `#`.

```text
The customer catalogue reads are whole-boundary mocks
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)) — the rule
needs the key
list, and the candidates rule normalizes a non-matching raw token through Get-AzureCustomer.
```
