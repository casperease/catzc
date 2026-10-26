# pwsh/Base.Contracts/types/ContractLayout.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class ContractLayout`, written with `//`.

```text
What the contracts tree holds at one level: the folders and files directly in a folder, listed through the bounded walker with the
folder-walk config's names pruned, in ordinal order. A folder the layout requires fails when it is missing, so a broken tree is named
where it breaks.
```

## comment:2

Above `public const string CurrentVersion = "0.1.0";`, written with `//`.

```text
The one version folder of every root that holds its current contracts
([ADR-REPO-CONTRACT-CURRENTVERSION](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-currentversion)).
```

## comment:3

Above `public const string ProvidedRoot = "catzc";`, written with `//`.

```text
The one root whose assets are provided; every other root is a vendor and its assets are depended-on
([ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)).
```
