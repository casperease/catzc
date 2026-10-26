# pwsh/Base.Variants/Assert-HaveCustomer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
