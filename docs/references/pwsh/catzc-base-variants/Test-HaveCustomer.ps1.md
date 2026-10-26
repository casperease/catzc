# pwsh/Base.Variants/Test-HaveCustomer.ps1

The singular cover over `Test-HaveCustomers`: it answers whether one named customer is enabled for the repo.

## help

### synopsis

Tests whether one named customer is enabled for the repo (singular cover over Test-HaveCustomers).

### description

The single-customer form of Test-HaveCustomers, for the common "is this one customer enabled" check. A thin cover: Test-HaveCustomers -Name
$Name. Returns $true when the `have_customers` variant is 'all' or includes the name.

### parameter `Name`

The customer name to test.

### example 1

```powershell
if (Test-HaveCustomer acme) { ... }
```
