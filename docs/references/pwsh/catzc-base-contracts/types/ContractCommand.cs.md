# pwsh/Catzc.Base.Contracts/types/ContractCommand.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static IReadOnlyList<string> Compare(ContractCommand contract,...`, written with `//`.

```text
The findings of a contract against the signature read from the command's file: every disagreement, each as one message
(ADR-REPO-CMDCONTRACT#4). A computed default on the command's side is not compared.
```

## comment:2

Above `public ContractCommand(ContractAsset asset, IDictionary raw) : this(raw)`, written with `//`.

```text
The contract of one command asset: the asset names the command
([ADR-REPO-CMDCONTRACT#3](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract3)), raw is its parsed document.
```
