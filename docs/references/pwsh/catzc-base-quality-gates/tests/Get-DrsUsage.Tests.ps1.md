# pwsh/Base.QualityGates/tests/Get-DrsUsage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$one = @(Get-DrsUsage -Path (Join-Path (Get-RepositoryRoot) $path))`, written with `#`.

```text
An absolute path: a relative one resolves against the process location, which a test worker does not hold at
the root.
```
