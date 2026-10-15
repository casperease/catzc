---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
    kind: comment-page
    body_sha: "32c23d9e69b4"
    adrs:
      - ADR-AUTO-TEST#37
      - ADR-FLOW-CD-GLOBS#7
---

# automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The -Suite resolver. A test suite is a named, declared selection of tests
([ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)): a globset's `verify:` scope, the
modules whose tests verify a change in that area-of-control and the tier to run them through (the blast-radius marker
role, [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)). This looks the named globset
up in the registry (an unknown name throws there, naming the config) and returns that scope. A globset without a
verify scope is not a test suite; it throws with the remedy: declare one in globs.yml.
```
