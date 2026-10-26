# pwsh/Base.QualityGates/tests/types/CommentsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'CommentsConfig'`, written with `#`.

```text
CommentsConfig maps comments.yml and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): an omitted key
behaves exactly like the default, and a malformed value fails at construction naming the key.
```
