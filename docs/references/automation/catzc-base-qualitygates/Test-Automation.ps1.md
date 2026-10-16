---
catzc:
  immutable:
    with_body_sha: "8dc164acfb05"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: test-automation-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{30,37}
---

# automation/Catzc.Base.QualityGates/Test-Automation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($Suite) {`, written with `#`.

```text
-Suite: run a test suite — the named globset's declared verify scope resolves to the module list and tier
(Resolve-TestSuite, [ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)).
```

## comment:2

Above `Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation'...`, written with `#`.

```text
The harness itself — discovery, tag checks, sharding, workers, rows, reports — is the core both runs
share (Invoke-TestRun,
[ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)). The source run loads each
worker through the
repository importer, the core's default.
```
