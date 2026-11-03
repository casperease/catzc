# pwsh/Base.Exporter/tests/Build-Modules.Languages.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$script:installs = @{}`, written with `#`.

```text
A foreign git repository and a folder with no repository each take a fresh install of the bundle
([ADR-REPO-REPOKIND-NOREPO](/docs/drs/repository/repository-kinds.md#rule-adr-repo-repokind-norepo)).
```
