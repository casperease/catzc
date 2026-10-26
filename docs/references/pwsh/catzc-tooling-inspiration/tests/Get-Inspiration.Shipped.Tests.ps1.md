# pwsh/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Shipped.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-Inspiration over the shipped inspiration.yml'`, written with `#`.

```text
The shipped inspiration.yml through the real Get-Config and the real repository root. It asserts consistency, never
presence: on a machine without eac the default inspiration is reported unavailable, and the test still passes
([ADR-REPO-INSPIRE-SIBLINGFORIDEAS](/docs/drs/repository/inspiration.md#rule-adr-repo-inspire-siblingforideas)).
```

## comment:2

Above `Describe 'Get-Inspiration over the shipped inspiration.yml'`, written with `#`.

```text
Consistency, never presence: on a machine without the sibling checkout it is reported unavailable and the test still
passes.
```
