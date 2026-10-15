---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/tests/Build-RootConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "8c2688d4bf0b"
    adrs:
      - ADR-AUTO-TEST#14
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1

<!-- cspell:ignore nbeta nmodule -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:fake = New-FakeRepositoryRoot -Files @{`.

```text
Isolate through the seams
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): mock the
config seam (Get-Config) and the generator
dispatch, and redirect the repository root to a fixture tree (TestKit) so Resolve-RepoPath binds
inside it.
```

## comment:2

Above `Mock Set-FileLink -ModuleName Catzc.Base.RootConfig { $false }`.

```text
The link mechanism is its own unit (Set-FileLink.Tests.ps1) — here it is a mocked boundary, so these
tests assert only that the link branch dispatches to it and skips content composition.
```

## comment:3

Above `$sourceOnDisk = Join-Path $script:fake.Root 'sources/fixture.yml'`.

```text
An entry flipped back from copyAsLink: the leftover link reads the same as the source, so only the is-link
check can convert it back into an independent file.
```

## comment:4

Above `$script:fake = New-FakeRepositoryRoot -Files @{`.

```text
A wildcard entry whose generator renders one { Target; Content } record per file; every file is written
on its own and reported in its own row. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:5

Above `$script:goRoot = $_`.

```text
The wiring the L0 tests mock away on both sides: a fixture registry names New-GoWorkspace, the real dispatch
calls it, and Build-RootConfig writes what it renders. Only the registry, the run mode, and the go pin are
mocked, so the result is independent of the shipped config
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)).
```
