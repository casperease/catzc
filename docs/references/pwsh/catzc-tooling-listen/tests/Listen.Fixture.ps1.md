# pwsh/Catzc.Tooling.Listen/tests/Listen.Fixture.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Write-ListenFixtureFile {`, written with `#`.

```text
The shared fixture of the listen tests: a repository in TestDrive with a watched docs folder, a fast config, and the mocks that bind
the module to them. Dot-sourced from each test file's BeforeAll; Initialize-ListenFixture is called once per test that needs a fresh tree.
```

## comment:2

Above `Mock Get-ListenDiff -ModuleName Catzc.Tooling.Listen {`, written with `#`.

```text
Get-ListenDiff launches git (git diff --no-index), which the fast tiers never do (ADR-AUTO-TEST-PROCESSTRIPWIRE): this stand-in diffs
the two sides' lines in memory and yields the same shape, the one hunk from its header on, empty when the sides are equal.
```

## comment:3

Above `function Write-ListenFixtureFile {`, written with `#`.

```text
A watched docs folder in TestDrive with short timings, so a listen test never touches the real tree or waits on real
timers.
```

## comment:4

Above `Mock New-RepositorySnapshot -ModuleName Catzc.Tooling.Listen {`, written with `#`.

```text
The committed reference: the fixture's files as committed, plus a code file and a binary one outside the watched
folder.
```
