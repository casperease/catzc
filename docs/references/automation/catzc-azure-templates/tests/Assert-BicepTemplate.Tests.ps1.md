---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Assert-BicepTemplate.Tests.ps1.md
    kind: test-asset
    body_sha: "3e5ec1b071e8"
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-REPO-OUTDIR#3
---

# automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1

<!-- cspell:ignore brkn -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `InModuleScope Catzc.Base.Config { $script:configCache = $null }`.

```text
Reset the caches ONCE (not per test): the mocked config is the SAME fixture azure.yml for every
test, so clearing $configCache in BeforeEach only forced a needless cold re-parse (~65ms/test).
Cleared once here drops any real-config entry a prior test file may have left; the fixture config
then stays warm across this block. (Assert-BicepTemplate never calls Get-BicepTemplates, but we
drop any stale template-cache entry too, for good measure.)
```

## comment:2

Above `BeforeAll {`.

```text
These never mutate the tree, so they validate the COMMITTED fixtures directly — no per-test
Copy-Directory (~41ms each, [ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
Assert-BicepTemplate only reads; it cannot corrupt them.
```

## comment:3

Above `$script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())`.

```text
Validate against a writable COPY of the fixtures so a test can introduce a deliberate violation
without touching the committed fixtures. Each of these tests corrupts 'sample' (or adds a broken
template) differently and expects a specific throw, so they collide — a FRESH, UNIQUE root per
test under $TestDrive (Pester auto-cleans it) is required. A unique dir is also never re-deleted
mid-run, so it cannot race a concurrent file scanner (on-access AV / search indexer) holding the
just-copied PrePost.psm1 open and intermittently throwing "used by another process". Scratch
lives in temp, not out/
([ADR-REPO-OUTDIR#3](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir3)).
Copy-Directory (raw [System.IO]) instead of Copy-Item -Recurse: ~15x faster per tree here.
```

## comment:4

Above `[System.IO.File]::WriteAllText((Join-Path $script:templatesRoot...`.

```text
Add a slotted config beside sample's existing non-slotted ones — no longer a violation.
beta resolves to core_lower, so beta-001 is a valid slotted root config.
```

## comment:5

Above `[System.IO.Directory]::CreateDirectory((Join-Path $script:templatesRoot...`.

```text
globex is a defined customer with NO subscription in the fixture azure.yml, so a
configuration/globex/ config can never resolve to a subscription id.
```

## comment:6

Above `[System.IO.File]::WriteAllText((Join-Path $script:templatesRoot...`.

```text
One config trips two rules at once: a per-subscription env on a standard template (env-class)
AND a parameter main.bicep does not declare.
```

## comment:7

Above `BeforeAll {`.

```text
The build and the parameter check are each covered on their own (Build-Bicep.*.Tests.ps1,
Get-BicepParameterViolations.Tests.ps1); here both are mocked at the boundary, so this proves only the
wiring: -Build builds, then reports every parameter violation in the consolidated error.
```
