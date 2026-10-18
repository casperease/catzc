# pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-ValidRaw {`, written with `#`.

```text
Neutral fixtures ([ADR-REPO-LANG](/docs/adr/repository/domain-language-separation.md)): invented
domains/codes, never real ADR vocabulary. Defined in
BeforeAll so the helper is in scope for the run phase and visible to every It (a Describe-body function is
only in discovery scope).
```
