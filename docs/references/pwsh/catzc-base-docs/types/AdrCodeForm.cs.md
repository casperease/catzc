# pwsh/Catzc.Base.Docs/types/AdrCodeForm.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class AdrCodeForm`, written with `//`.

```text
The ADR code grammar (ADR-REPO-ADRCODE), and the shortest form of a derived list of codes.

  ADR-<DOMAIN>-<ADR>-<NAME>   one rule
  ADR-<DOMAIN>-<ADR>          the whole ADR, every rule of it
  ADR-<DOMAIN>                every ADR of the domain

A code is a path of upper-case segments, and a prefix selects everything below it. There is no number, group or range.
```

## comment:2

Above `public static IReadOnlyList<string> Minimize(string[] codes, AdrCitationMap...`, written with `//`.

```text
A derived list at its shortest: a code another listed code covers goes, and a set of rules that is every rule of its ADR, as the registry
declares them, becomes the ADR's code. Without a registry nothing collapses, and the list is ordinal; with one it is in authored order.
```
