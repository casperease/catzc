# pwsh/Catzc.Base.Contracts/types/ContractLayout.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class ContractLayout`, written with `//`.

```text
What the contracts tree holds at one level: the folders and files directly in a folder, listed through the bounded walker with the
folder-walk config's names pruned, in ordinal order. A folder the layout requires fails when it is missing, so a broken tree is named
where it breaks.
```
