# automation/Catzc.Base.Variants/Test-HaveCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether the repo has customer deployments enabled — for all customers, or for specific names.

### description

A predicate over the `have_customers` repo-wide variant (see Get-EnabledCustomers). With no -Name it answers "is the repo customer-enabled
at all" (the variant is 'all' or a non-empty list). With -Name it answers "are all the named customers enabled" (the variant is 'all', or
each name is in the list). A guard callable anywhere above the Config layer; use Assert-HaveCustomers to fail instead of branch.

Enabled here means enabled by repo policy (the variant). Whether a name is a _defined_ customer is a customer.yml (Azure-layer) concern.

### parameter Name

Zero or more customer names to test for enablement. Omit to test the repo-wide capability.

### example 1

```powershell
if (Test-HaveCustomers) { ... }              # any customers enabled?
```

### example 2

```powershell
Test-HaveCustomers -Name acme, globex        # are both enabled?
```

## comment:1

Above `foreach ($customer in $Name) {`, written with `#`.

```text
Enabled names and the query names are both lowercase-validated, so plain (case-insensitive) membership
is equivalent here and needs no case-sensitive operator.
```
