# pwsh/Base.Variants/Assert-HaveCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts the repo has customer deployments enabled — for all customers, or for specific names — else throws.

### description

The throwing companion to Test-HaveCustomers. With no -Name it requires the repo to be customer-enabled at all; with -Name it requires every
named customer to be enabled. Throws naming the disabled or not-enabled customer(s) and pointing at the `have_customers` variant. Guards a
customer-only code path.

### parameter `Name`

Zero or more customer names to require. Omit to require the repo-wide capability.

### example 1

```powershell
Assert-HaveCustomers
```

### example 2

```powershell
Assert-HaveCustomers -Name acme
```
