# pwsh/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Catzc.Tooling.Inspiration.InspirationRoot'`, written with `#`.

```text
InspirationRoot over neutral fixture paths (widget/gadget,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)): the {workspace} anchor resolves to
the parent of the repository root ([ADR-AUTO-PATH-WORKSPACEANCHOR](/docs/drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)),
identically from pwsh's and Git Bash's view of that root. The platform is a parameter, so every branch runs on
every OS.
```
