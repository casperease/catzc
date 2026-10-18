# automation/Catzc.Azure.Templates/tests/Get-AzureResourceName.Tests.ps1

<!-- cspell:ignore alweutstsmplst weuwkspvm sttstsmplalweu alweusmplvm vmsmplalweu weutstsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The pattern selects the env-segment (long → name, restricted → shortcode) and the separator
(hyphen for long/kv, none for storage/vm); the order arranges the segments. Base slot, so the
slot segment is dropped.
```
