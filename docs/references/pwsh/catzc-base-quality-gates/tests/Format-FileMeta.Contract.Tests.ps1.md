# pwsh/Catzc.Base.QualityGates/tests/Format-FileMeta.Contract.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'The provided head contract'`, written with `#`.

```text
The provided head contract names the keys of a file's meta head; this proves they are the keys the code writes, so
neither can drift.
```

## comment:2

Above `$script:writtenImmutable = @($composed | Sort-Object -Unique)`, written with `#`.

```text
The generated-file head holds place facts only, under immutable; the imprint kinds write the edges at the
block's first level.
```
