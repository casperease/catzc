# automation/Catzc.Base.Contracts/types/ContractParameter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `private static readonly Regex SpecRe = new Regex(`, written with `//`.

```text
spec = type [ "!" ] [ "=" literal ] [ "pipeline" ]; type = base [ "[]" ]
([ADR-REPO-CMDCONTRACT#2](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract2)).
```
