# pwsh/Base.Variants/Assert-HaveCustomer.ps1

The singular cover over `Assert-HaveCustomers`: a caller that needs one customer names it, and a repo that has not enabled it stops with a
named error.

## help

### synopsis

Asserts one named customer is enabled for the repo, else throws (singular cover over Assert-HaveCustomers).

### description

The single-customer form of Assert-HaveCustomers. A thin cover: Assert-HaveCustomers -Name $Name. Throws when the named customer is not
enabled by the `have_customers` variant.

### parameter `Name`

The customer name to require.

### example 1

```powershell
Assert-HaveCustomer acme
```
