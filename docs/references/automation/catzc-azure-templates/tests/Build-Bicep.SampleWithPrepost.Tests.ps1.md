---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3964af3f98e4"
    adrs:
      - ADR-AUTO-TEST#{19,20}
---

# automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:alphaNetwork = (Get-Config -Config network).environments.alpha`, written with `#`.

```text
The merge seam injects the vnet ranges from the network fixture — resolve the expected,
per-env values straight from the asset so the test tracks it.
```

## comment:2

Above `Get-Config -Config azure | Out-Null`, written with `#`.

```text
Warm the path-keyed session caches once, not per test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```

## comment:3

Above `$script:configRoot = Join-Path (Get-RepositoryRoot)...`, written with `#`.

```text
ONE build of ALL environments is the single observation every assertion below is a facet of
([ADR-AUTO-TEST#20](/docs/adr/automation/test-automation.md#rule-adr-auto-test20)) — not a rebuild per test.
Building all envs yields alpha AND beta, so every
per-env range/vnet/reference check reads the captured output rather than re-invoking Build-Bicep.
Under the sharded/greedy run a Build-Bicep call (PrePost import + file I/O) costs ~5-6x its warm
solo time from CPU/IO contention; collapsing six builds to one keeps every It within the L0 time budget.
```

## comment:4

Above `$configuration = Get-Content (Join-Path $script:configRoot 'alpha.yml') -Raw...` (occurrence 2), written with `#`.

```text
The config does NOT carry the value — the hook injects an ARM KV *reference* (the production
pattern for keeping deploy-time secrets out of the repo, here proven on a fixture so no test binds
to a real template's secret name).
```
