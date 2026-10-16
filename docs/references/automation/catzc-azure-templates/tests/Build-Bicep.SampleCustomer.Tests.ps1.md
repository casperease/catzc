---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleCustomer.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6ee02cb6fadb"
    adrs:
      - ADR-AUTO-TEST#{4,19,26}
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1

<!-- cspell:ignore alweutstscusst alweutstscusacst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Boundary mocks + config-cache reset run ONCE (the mocked config is identical every test); only the
build output folder is wiped per test, since the build tests write into it
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```

## comment:2

Above `Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName...`, written with `#`.

```text
Isolate build output to this file's throwaway $TestDrive via the output-root seam
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)), so
it never shares out/template/<name> with Build-Bicep.L2 or the other sample files — the sharing the
'serial' tag used to work around
([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)). Mocking the seam removes
the sharing (so this runs in
parallel), and Pester auto-cleans $TestDrive, so no manual output teardown is needed.
```

## comment:3

Above `Get-BicepTemplate sample-customer | Out-Null`, written with `#`.

```text
Warm the discovery + config caches once so the first It doesn't pay the cold Get-BicepTemplate derive
inside its own timing now that this file runs in the (timed) parallel phase
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```
