# pwsh/Base.Folders/tests/types/FolderWalkConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'FolderWalkConfig'`, written with `#`.

```text
FolderWalkConfig maps folder-walk.yml and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): an omitted key behaves exactly like the
default, and a malformed value fails at construction with every violation named.
```

## comment:2

Above `Describe 'FolderWalkConfig'`, written with `#`.

```text
The type is the only place a folder-walk default lives, so an omitted key and its default must be indistinguishable to
every walker.
```
