# pwsh/Base.QualityGates/types/CommentLexer.cs

Finds the comment spans of a source file, the only places a code link lives
([ADR-REPO-LINK-KINDBYFILE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-kindbyfile)). It works per language family,
chosen by file extension, and is the one place that knows comment syntax.

## Families

| Family     | Extensions                    | Comments                                                                           |
| ---------- | ----------------------------- | ---------------------------------------------------------------------------------- |
| PowerShell | `.ps1` `.psm1` `.psd1`        | the real PowerShell tokenizer's comment tokens, line comments and `<# #>` blocks   |
| C family   | `.cs` `.bicep`                | `//` and `/* */`, `///` included, skipping string, verbatim, raw and char literals |
| Hash       | `.yml` `.yaml`                | `#` at line start or after whitespace, outside quoted scalars and block scalars    |
| XML        | `.csproj` `.props` `.targets` | `<!-- -->`                                                                         |

## Strings

It also returns the string-literal spans, which hold docs paths and citations as data
([ADR-REPO-LINK-STRINGSAREDATA](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-stringsaredata)). `Strings` returns them for
any code file, quotes included: PowerShell's string tokens, the C family's literals (regular, verbatim, interpolated, raw) and each YAML
line's non-blank text outside its comment, since a YAML value is data however it is quoted. XML has none, because its text is not code.

Spans are `(Start, Length)` offsets into the text, in document order. The C family comes from one scan that skips each kind while it looks
for the other, whether the caller wants comments or strings.

## Line marker

`LineMarker` gives the marker that continues a wrapped line comment: `///`, `//` or `#`. A block comment (`<# #>`, `/* */`, `<!-- -->`) has
none, so its continuation is plain indentation and the method returns null.
