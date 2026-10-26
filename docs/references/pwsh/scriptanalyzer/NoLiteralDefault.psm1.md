# pwsh/.scriptanalyzer/NoLiteralDefault.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$isConfigRead = {`, written with `#`.

```text
The variables the function fills from a config read, directly or through a member of one: $settings =
Get-Config ...
```
