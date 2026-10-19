# pwsh/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1

<!-- cspell:ignore nbeta nmodule -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:fake = New-FakeRepositoryRoot -Files @{`, written with `#`.

```text
Isolate through the seams
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): mock the
config seam (Get-Config) and the generator
dispatch, and redirect the repository root to a fixture tree (TestKit) so Resolve-RepoPath binds
inside it.
```

## comment:3

Above `$sourceOnDisk = Join-Path $script:fake.Root 'sources/fixture.yml'`, written with `#`.

```text
A target left as a link reads the same as its source, so only the is-link check converts it into an
independent file, and the source is never written through it.
```

## comment:4

Above `$script:fake = New-FakeRepositoryRoot -Files @{` (occurrence 2), written with `#`.

```text
A wildcard entry whose generator renders one { Target; Content } record per file; every file is written
on its own and reported in its own row. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:5

Above `$script:goRoot = $_`, written with `#`.

```text
The wiring the L0 tests mock away on both sides: a fixture registry names New-GoWorkspace, the real dispatch
calls it, and Build-RootConfig writes what it renders. Only the registry, the run mode, and the go pin are
mocked, so the result is independent of the shipped config
([ADR-AUTO-TEST-LOGICANDINTEGRITY](/docs/adr/automation/test-automation.md#rule-adr-auto-test-logicandintegrity)).
```
