# pwsh/Catzc.Base.Objects/tests/types/SentenceGuid.Tests.ps1

<!-- cspell:ignore oilzstgq -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$result = [Catzc.Base.Objects.SentenceGuid]::Convert('!!! ??? ,,,')`, written with `#`.

```text
Compared as [guid]::Empty, not a literal — the all-zeros GUID is on the registry's denied list
and never appears in tracked text.
```
