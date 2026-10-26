# pwsh/Base.Variants/Test-HaveCustomers.ps1

The query form of the customer guard: it answers from `Get-EnabledCustomers` whether the repo deploys customers at all, or deploys every
named one, and `Assert-HaveCustomers` throws on the same answer.

## help

### synopsis

Tests whether the repo has customer deployments enabled — for all customers, or for specific names.

### description

A predicate over the `have_customers` repo-wide variant (see Get-EnabledCustomers). With no -Name it answers "is the repo customer-enabled
at all" (the variant is 'all' or a non-empty list). With -Name it answers "are all the named customers enabled" (the variant is 'all', or
each name is in the list). A guard callable anywhere above the Config layer; use Assert-HaveCustomers to fail instead of branch.

Enabled here means enabled by repo policy (the variant). Whether a name is a _defined_ customer is a customer.yml (Azure-layer) concern.

### parameter `Name`

Zero or more customer names to test for enablement. Omit to test the repo-wide capability.

### example 1

```powershell
if (Test-HaveCustomers) { ... }              # any customers enabled?
```

### example 2

```powershell
Test-HaveCustomers -Name acme, globex        # are both enabled?
```

## Name matching

Both the enabled names and the names asked about are validated as lowercase, so plain case-insensitive membership gives the same answer as a
case-sensitive one would.
