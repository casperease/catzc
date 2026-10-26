# pwsh/Base.Docs/tests/Get-ReadmeMappings.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ReadmeMappings'`, written with `#`.

```text
Get-ReadmeMappings is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)).
```

## comment:2

Above `$script:root = Join-Path $TestDrive ([guid]::NewGuid())`, written with `#`.

```text
Fixture repo: widgets/<modules> + a dot-dir; reference articles, as the sources, for two of the three
modules.
```

## comment:3

Above `InModuleScope Catzc.Base.Docs {`, written with `#`.

```text
No Root plumbing: the glob-shape check throws before RepositoryRoot is ever read, so a literal
placeholder root is enough here.
```

## comment:4

Above `Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }`, written with `#`.

```text
The source-tree guard is its own unit (below); here the fixture stands in for the source tree in either run
mode.
```
