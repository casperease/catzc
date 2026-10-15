---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplates.Tests.ps1.md
    kind: test-asset
    body_sha: "4e7ddebb7c01"
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#4
---

# automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1

<!-- cspell:ignore sampl deriv -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Read-only discovery tests: boundary mocks + config-cache reset run ONCE, not per test. Discovery
(bicepTemplatesCache) already caches on the fixture root across tests, and no test mutates the fixture
tree or config, so the warm caches are correct to share; a per-test configCache reset only forced a
needless cold re-parse
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)). The cache-behavior tests below invalidate bicepTemplatesCache
inside their own It, independent of this setup.
```

## comment:2

Above `Mock Get-BicepTemplatesRoot {`.

```text
Discover from the test fixtures, never the shipped infrastructure/templates — and resolve
identity (env/customer validation) from the test config fixture, never the shipped azure.yml.
```

## comment:3

Above `$shippedRoot = Join-Path (Get-RepositoryRoot) 'infrastructure/templates'`.

```text
Must NOT be the shipped repo-root infrastructure/templates tree. (Matched against the actual
shipped root, not a '*infrastructure*templates*' substring — the module folder is now named
Catzc.Azure.Templates, so the fixture path legitimately contains 'infrastructure' too.)
```
