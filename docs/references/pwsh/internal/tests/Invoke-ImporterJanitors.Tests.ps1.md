# pwsh/.internal/tests/Invoke-ImporterJanitors.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:writers = [ordered]@{}`, written with `#`.

```text
The registry the janitor reads: the eight at-import writers in the order the import runs them, and one writer
the import leaves alone.
```
