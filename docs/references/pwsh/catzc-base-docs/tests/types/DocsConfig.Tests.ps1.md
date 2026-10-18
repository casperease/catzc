# automation/Catzc.Base.Docs/tests/types/DocsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'DocsConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
Validates the compiled DocsConfig / DocMapping / DocPattern types directly — the constructor is the gate
that stops a malformed or duplicated readme.yml registry from ever producing an instance.
```
