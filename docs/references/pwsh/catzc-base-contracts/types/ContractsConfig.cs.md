# pwsh/Base.Contracts/types/ContractsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class ContractsConfig`, written with `//`.

```text
How a contract group folder is named, and nothing else: contracts are addressed by root, version, group and file
(ContractLayout), never by a mode set here. A group is the module's track and its folder in the normal form
(pwsh.base.vs_code for Catzc.Base.VSCode); an exception names one module's group outright, for the rare module the
rule names wrongly.
```
