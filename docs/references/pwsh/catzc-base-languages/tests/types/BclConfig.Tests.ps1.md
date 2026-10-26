# pwsh/Base.Languages/tests/types/BclConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:solutions = @{ 'catzc.sln' = New-Solution }`, written with `#`.

```text
The one solution is rendered (New-Solution) and gitignored, so its text is the generator's, never a
tracked file's.
```
