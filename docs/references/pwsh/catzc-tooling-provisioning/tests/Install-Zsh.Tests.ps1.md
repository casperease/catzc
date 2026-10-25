# pwsh/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Install-Zsh'`, written with `#`.

```text
Install-Zsh on a fixture Git tree in $TestDrive: the layout, the tool config, the verified download, and the tar
extraction are mocked, so nothing downloads, no process starts, and nothing outside $TestDrive changes
([ADR-AUTO-TEST-NOCLOUDBELOWLTHREE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-nocloudbelowlthree)). The extraction mock writes a
fixture package with neutral names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Context 'on Linux' {`, written with `#`.

```text
The shared apt installer is mocked: it reads the package name from the entry's apt_package, so Install-Zsh names
only the tool, and nothing installs and no process starts.
```
