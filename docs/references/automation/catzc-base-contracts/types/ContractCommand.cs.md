# automation/Catzc.Base.Contracts/types/ContractCommand.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static IReadOnlyList<string> Compare(ContractCommand contract,...`, written with `//`.

```text
The findings of a contract against the signature read from the command's file: every disagreement, each as one message
(ADR-REPO-CMDCONTRACT#4). A computed default on the command's side is not compared.
```
