# pwsh/Base.Objects/tests/types/NameCase.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'NameCase'`, written with `#`.

```text
An acronym written as one capitalised word splits at its case step like any other word: DevOps is two words, dev and ops, in every case,
so a module named Widget.DevOps is widget.dev_ops in the snake normal form and widget-dev-ops in kebab case; a run of capitals before a
capitalised word ends at the run's last capital, so HTTPServer is http and server.
```
