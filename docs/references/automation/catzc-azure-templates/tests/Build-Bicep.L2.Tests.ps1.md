---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Build-Bicep.L2.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "2eec70cc401b"
    adrs:
      - ADR-AUTO-TEST#{8,26}
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Build-Bicep (walking skeleton — real az)' -Tag 'L2', 'logic',...`, written with `#`.

```text
Walking-skeleton L2 coverage for Build-Bicep: the few real `az bicep build` threads that exercise something
the mocked-az L0 logic tests cannot. The per-template RULE checks — parameter-file names, customer prefixes,
indexed slots, merged vnet ranges, injected Key Vault references, resource-group/deployment names — are
pushed left to the fast L0 logic blocks in Build-Bicep.Sample*.Tests.ps1 (which mock Invoke-AzCli so no real
build runs). This file keeps only the end-to-end COMPILE wiring (Build-Bicep -> Invoke-AzCli -> real az),
proven once on the broadest single thread, plus the two real-compiler capabilities the mock fakes away:
a subscription-scoped template compiling, and a local reusable module being inlined into main.json.
Each build asserts main.json (the compiled artifact — the integration concern) and, where the real
compiler does something the mock cannot, that specific output. It does NOT re-assert the rendered
parameter FILES: those are pure PowerShell covered at L0 (Sample*.Tests.ps1), `az` is invoked once
regardless of how many slots render, and binding L2 to files on the shared out/template/ path is the
reused-sandbox race the test-automation Gotchas warn about (main.json is the last, stable write).

Three builds, not one per sample: each adds a DISTINCT real-compiler concern. sample-indexed and
sample-with-prepost are deliberately absent — their behaviour (indexed slots, the PrePost merge seam) is pure
PowerShell fully covered at L0, and their compile is a flat resource-group build identical to the skeleton.
Each It self-skips when `az` is absent
([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)); the skip key is the constrained
`tool_az_missing` grammar.

Isolation is the standard seam swap
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): redirect the template
tree to tests/assets/templates and the
azure/network configs to the fixtures, so these bind to the sample-* assets, never to shipped templates.
greedy, not serial: it drives real `az bicep build` child processes (consuming the machine beyond this
process — [ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)) but shares no mutable
state. The build output is isolated to this file's own root via
the Get-BicepTemplatesOutputRoot seam (below), so it no longer races the L0 Build-Bicep.Sample*.Tests.ps1
files on out/template/<name> — which is what previously forced the serial tag.
```

## comment:2

Above `Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName...`, written with `#`.

```text
Isolate build output to this file's throwaway $TestDrive
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)) so the real-az
builds never
share out/template/<name> with the L0 sample files — removing the sharing that forced a serial tag.
Pester auto-cleans $TestDrive, so the per-test output teardown below is belt-and-suspenders only.
```

## comment:3

Above `Join-Path $script:outputRoot 'main.json' | Should -Exist`, written with `#`.

```text
main.json is the integration concern: the real compiler ran and Build-Bicep wired --outdir. The
per-(customer,slot) parameter files it also renders are pure PowerShell, asserted at L0
(Build-Bicep.SampleCustomer.Tests.ps1) — re-checking them here adds no real-compile coverage.
```
