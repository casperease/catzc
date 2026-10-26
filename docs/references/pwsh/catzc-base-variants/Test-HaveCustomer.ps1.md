# pwsh/Base.Variants/Test-HaveCustomer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
