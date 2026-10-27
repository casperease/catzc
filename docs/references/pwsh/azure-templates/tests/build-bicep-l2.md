# pwsh/Azure.Templates/tests/Build-Bicep.L2.Tests.ps1

The walking-skeleton L2 tests of `Build-Bicep`: the few real `bicep build` threads that exercise something the mocked-bicep L0 tests cannot.

## What lives where

The per-template rule checks (parameter file names, customer prefixes, indexed slots, merged vnet ranges, injected Key Vault references,
resource-group and deployment names) are pushed left to the fast L0 blocks in `Build-Bicep.Sample*.Tests.ps1`, which mock `Invoke-AzCli` so
no real build runs. This file keeps only the end-to-end compile wiring (`Build-Bicep`, `Invoke-AzCli`, real az), proven once on the broadest
single thread, plus the two real-compiler capabilities the mock fakes away: a subscription-scoped template compiling, and a local reusable
module being inlined into `main.json`.

There are three builds, not one per sample, because each adds a distinct real-compiler concern. `sample-indexed` and `sample-with-prepost`
are deliberately absent: their behaviour (indexed slots, the PrePost merge seam) is pure PowerShell fully covered at L0, and their compile
is a flat resource-group build identical to the skeleton.

## What a build asserts

Each build asserts `main.json`, the compiled artifact and the integration concern, and where the real compiler does something the mock
cannot, that specific output. It does not re-assert the rendered parameter files. Those are pure PowerShell covered at L0, `az` is invoked
once however many slots render, and binding L2 to files on the shared `out/template/` path is the reused-sandbox race the test-automation
gotchas warn about. `main.json` is the last, stable write.

## Skipping and isolation

Each `It` self-skips when the pinned `bicep` is absent
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)); the skip key is
the constrained `tool_az_missing` grammar.

Isolation is the standard seam swap
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): the
template tree is redirected to `tests/assets/templates` and the azure and network configs to the fixtures, so the tests bind to the
`sample-*` assets and never to shipped templates. The build output is isolated to this file's own `$TestDrive` through the
`Get-BicepTemplatesOutputRoot` seam, so the real-az builds never share `out/template/<name>` with the L0 sample files. Pester cleans
`$TestDrive`, so the per-test output teardown is belt and braces only.

The file is greedy, not serial: it drives real `bicep build` child processes, which consume the machine beyond this process
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)), but it shares no
mutable state. The shared output path is what previously forced the serial tag.

## The compiled artifact

`main.json` is the integration concern: the real compiler ran and `Build-Bicep` wired `--outdir`. The per-customer and per-slot parameter
files it also renders are asserted at L0 (`Build-Bicep.SampleCustomer.Tests.ps1`), and re-checking them here adds no real-compile coverage.
