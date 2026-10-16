---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Remove-LinuxToolInstall.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "107dce8802af"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:config = [pscustomobject]@{ command = 'widget'; pip_package =...`, written with `#`.

```text
A neutral fixture tool
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) — never a real tool identity.
```

## comment:2

Above `Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core`, written with `#`.

```text
Defaults: the tool is on PATH; dpkg / uv are absent; every external probe reports "not found".
Individual tests enable the mechanism they exercise.
```

## comment:3

Above `$strayPath = Join-Path $TestDrive 'widget'`, written with `#`.

```text
dpkg / uv both absent (defaults) — fall through to the stray-file delete. Point the command at a real
file under TestDrive so the delete has something to remove.
```
