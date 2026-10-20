# pwsh/Catzc.Tooling.Listen/tests/Listen.Fixture.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Write-ListenFixtureFile {`, written with `#`.

```text
The shared fixture of the listen tests: a repository in TestDrive with a watched docs folder, a fast config, and the mocks that bind
the module to them. Dot-sourced from each test file's BeforeAll; Initialize-ListenFixture is called once per test that needs a fresh tree.
```
