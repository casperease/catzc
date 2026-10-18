# pwsh/Catzc.Base.Docs/tests/types/DocMapping.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'DocMapping' -Tag 'L0', 'logic' {`, written with `#`.

```text
Validates the compiled DocMapping type directly — the constructor is the gate that stops a malformed
readme.yml mapping entry from ever producing an instance.
```
