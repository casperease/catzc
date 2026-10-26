# pwsh/Catzc.Base.VSCode/tests/New-VsCodeSettings.Tests.ps1

<!-- cspell:ignore gopls -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.VSCode {`, written with `#`.

```text
Isolate through the config seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): a small
fixture registry with an authored
search.exclude carrying an explicit un-exclude (false) that injection must not override.
```

## comment:2

Above `$text = New-VsCodeSettings -ManagedTarget 'go.work', '*/tests/*/go.mod'`, written with `#`.

```text
The managed Go targets (go.work and the generated go.mod files) are injected like every managed target;
the test code under either Go root must stay visible, searchable, watched, and loaded by gopls.
```

## comment:3

Above `$pattern = $glob -replace '\*\*', '*'`, written with `#`.

```text
A VS Code glob as a -like pattern ('**' and '*' both span '/'), on the path and its leading '**/'
form.
```
