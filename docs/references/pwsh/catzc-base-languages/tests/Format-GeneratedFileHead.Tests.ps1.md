# pwsh/Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:tracked = $true`, written with `#`.

```text
Whether git tracks the path: a tracked path comes back from the index read, an untracked one does not; a
fixture stands for it here.
```

## comment:2

Above ``$once | Should -BeLike "*#     with_body_sha: `"9e2ec912af5d`"`n*"``, written with `#`.

```text
The block renderer quotes a value YAML would not read back as the same string, so a hash that opens with a
digit is quoted.
```
