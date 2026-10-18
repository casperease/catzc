# automation/Catzc.Tooling.Python/tests/Invoke-Pip.L2.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-Pip' -Tag 'L2', 'logic' {`, written with `#`.

```text
The chain is Invoke-Pip → Invoke-Uv → uv pip <args>: uv is the tool that must exist, and it needs a
discoverable interpreter. There is no `uv pip --version` — `uv pip` is a subcommand group — so the
end-to-end contract is carried by a real subcommand.
```
