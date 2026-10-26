# pwsh/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Resolve-InspirationRoot'`, written with `#`.

```text
Resolve-InspirationRoot over a TestDrive workspace with neutral names (widget/gadget,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); Get-RepositoryRoot is the mocked
boundary. The {workspace} anchor resolves to the parent of the repository root
([ADR-AUTO-PATH-WORKSPACEANCHOR](/docs/drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)), the same from pwsh's and
Git Bash's view of that root, and the result is a normalized absolute path.
```

## comment:2

Above `Describe 'Resolve-InspirationRoot'`, written with `#`.

```text
The root is fed in both shells' views of the same folder, so the anchor resolving differently per shell would fail
here.
```
