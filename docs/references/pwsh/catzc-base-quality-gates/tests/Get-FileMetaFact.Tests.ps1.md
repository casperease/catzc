# pwsh/Base.QualityGates/tests/Get-FileMetaFact.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `InModuleScope Catzc.Base.QualityGates {`, written with `#`.

```text
Two fixture kinds with fixture processors: a fixed shade, and a tint read from the file's body, never from its
head.
```

## comment:2

Above `$script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{})`, written with `#`.

```text
A fixture registry: the `classes` of a test's raw config become the kinds the file-kinds registry names, and
none leaves every file other.
```
