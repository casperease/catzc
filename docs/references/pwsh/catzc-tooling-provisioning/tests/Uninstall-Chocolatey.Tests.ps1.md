# pwsh/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
Hermetic: every boundary outside the repository is mocked — the admin check, the directory delete, the
persistent variable (Set-PermanentEnvironmentVariable) and the persistent PATH (Get-/Set-EnvironmentPath).
The seams' real registry round trips are their own L3 system tests
([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)).
```
