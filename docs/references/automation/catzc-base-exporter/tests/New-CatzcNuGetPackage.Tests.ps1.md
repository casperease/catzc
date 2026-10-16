---
catzc:
  immutable:
    with_body_sha: "207896489921"
    path: docs/references/automation/catzc-base-exporter/tests/New-CatzcNuGetPackage.Tests.ps1.md
    folder: docs/references/automation/catzc-base-exporter/tests
    name: new-catzc-nu-get-package-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{3,20}
---

# automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1

<!-- cspell:ignore nfunction -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:source = Join-Path $TestDrive...`, written with `#`.

```text
A minimal fixture build (neutral names,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)), packed ONCE: every
assertion below is a facet
of the one pack ([ADR-AUTO-TEST#20](/docs/adr/automation/test-automation.md#rule-adr-auto-test20)) —
Compress-PSResource costs real time.
```
