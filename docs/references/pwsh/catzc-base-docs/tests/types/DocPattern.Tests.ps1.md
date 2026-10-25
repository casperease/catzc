# pwsh/Catzc.Base.Docs/tests/types/DocPattern.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'DocPattern'`, written with `#`.

```text
Validates the compiled DocPattern type directly — the constructor is the gate that stops a malformed
readme.yml patterns entry from ever producing an instance.
```
