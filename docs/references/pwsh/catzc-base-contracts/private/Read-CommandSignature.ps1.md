# pwsh/Catzc.Base.Contracts/private/Read-CommandSignature.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads a PowerShell command's signature from its file, without loading it, as a ContractCommand.

### description

The PowerShell checker's reading side
([ADR-REPO-CMDCONTRACT#4](../../../../adr/repository/command-contracts.md#rule-adr-repo-cmdcontract4)): the file is parsed, never run or
imported, and the named function's parameter block becomes one ContractParameter per parameter, in the same shape a contract parses to, so
ContractCommand.Compare can hold the two against each other.

- The type is the parameter's type constraint, mapped to the contract's closed set (string, int, bool, switch, a `Catzc.*` type, '`[]`' for
  an array); a type outside the set keeps its own name, so the comparison names it, and an untyped parameter is 'object'.
- Mandatory and pipeline come from the Parameter attribute's Mandatory and ValueFromPipeline arguments, bare or set to $true.
- A constant default (a string, a number, $true or $false) is its text; $null is no default; any other expression is
  ContractParameter.ComputedDefault, which the comparison does not compare.
- The output is the first type the OutputType attribute names, mapped the same way; no attribute is void.

A file that does not parse, or defines no function of the name, throws a message naming the file.

### parameter `Path`

The absolute path of the command's file.

### parameter `Name`

The function's name, Verb-Noun.

### outputs

`[Catzc.Base.Contracts.ContractCommand]` The signature as read.

### example 1

```powershell
Read-CommandSignature -Path $file -Name Get-Widget
```
