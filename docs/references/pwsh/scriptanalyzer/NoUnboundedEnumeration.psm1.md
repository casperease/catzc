# pwsh/.scriptanalyzer/NoUnboundedEnumeration.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$providerPath = $false`, written with `#`.

```text
A literal provider path (env:, function:, HKLM:) lists a provider, not the filesystem; a drive name of one
letter is a filesystem drive.
```
