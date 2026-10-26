# pwsh/Base.CodeMeta/tests/types/CodeMetaHead.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'CodeMetaHead and the types hash agree on every C# type'`, written with `#`.

```text
The types hash strips the head before the types load, so it cannot call CodeMetaHead; this proves the two read every
real type the same.
```
