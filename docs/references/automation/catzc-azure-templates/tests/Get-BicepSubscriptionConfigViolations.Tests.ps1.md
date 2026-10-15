---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepSubscriptionConfigViolations.Tests.ps1.md
    kind: test-asset
    body_sha: d76202b17b9b
    adrs:
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Azure.Templates/tests/Get-BicepSubscriptionConfigViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:azure = [ordered]@{`.

```text
Fixture azure: a non-customer pair (the shared platform) + a customer pair (acme) + a second
rogue non-customer subscription that overlaps core_lower on beta (the root-ambiguity case).
```

## comment:2

Above `Mock Get-AzureCustomers { @('acme', 'globex') } -ModuleName...`.

```text
The customer catalogue reads are whole-boundary mocks
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)) — the rule
needs the key
list, and the candidates rule normalizes a non-matching raw token through Get-AzureCustomer.
```
