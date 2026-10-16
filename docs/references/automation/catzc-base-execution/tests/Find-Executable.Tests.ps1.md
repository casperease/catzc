---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/Find-Executable.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b42819bf7f7b
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Find-Executable' -Tag 'L1', 'logic' {`, written with `#`.

```text
Hermetic logic (L1): the candidate executables are fixture files under $TestDrive, reached through a fixture
environment variable so the %VAR% expansion is exercised; the session actor, the PATH lookup and the version run
(Get-ExecutableVersion, the probe's only process start) are mocked. Fixture tokens are neutral
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `InModuleScope Catzc.Base.Execution { $script:executableVersionCache = $null }`, written with `#`.

```text
Every test here exercises the version cache entry, so each starts cold
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)).
```
