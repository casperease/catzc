# pwsh/Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1

<!-- cspell:ignore brkn -->

The L0 tests of the consolidated template validator.

## Caches

The caches are reset once, not per test. The mocked config is the same fixture `azure.yml` for every test, so clearing `$configCache` before
each test only forced a needless cold re-parse of about 65 ms per test. Clearing it once drops any real-config entry a prior test file left,
and the fixture config then stays warm across the block. `Assert-BicepTemplate` never calls `Get-BicepTemplates`, but the stale
template-cache entry is dropped too.

## Read-only and writable fixtures

The read-only tests never mutate the tree, so they validate the committed fixtures directly, with no per-test `Copy-Directory` of about 41
ms each ([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)). The validator only reads,
so it cannot corrupt them.

The tests that introduce a deliberate violation validate a writable copy. Each corrupts `sample`, or adds a broken template, differently and
expects a specific throw, so they would collide. Each test therefore gets a fresh, unique root under `$TestDrive`, which Pester cleans. A
unique directory is never re-deleted mid-run, so it cannot race a file scanner, such as on-access antivirus or the search indexer, that
holds the just-copied `PrePost.psm1` open and intermittently throws "used by another process". Scratch lives in temp, not `out/`
([ADR-REPO-OUTDIR-TEMPFORSCRATCH](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-tempforscratch)).
`Copy-Directory`, raw `[System.IO]`, is about 15 times faster per tree than `Copy-Item -Recurse` here.

## Cases

- A slotted config added beside `sample`'s non-slotted ones is no longer a violation: `beta` resolves to `core_lower`, so `beta-001` is a
  valid slotted root config.
- `globex` is a defined customer with no subscription in the fixture `azure.yml`, so a `configuration/globex/` config can never resolve to a
  subscription id.
- One config trips two rules at once: a per-subscription environment on a standard template (environment class) and a parameter `main.bicep`
  does not declare.
- The build and the parameter check are each covered on their own (`Build-Bicep.*.Tests.ps1`, `Get-BicepParameterViolations.Tests.ps1`).
  Here both are mocked at the boundary, so the test proves only the wiring: `-Build` builds, then reports every parameter violation in the
  consolidated error.
