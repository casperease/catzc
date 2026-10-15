---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/test-policy.yml.md
    kind: reference
    body_sha: "2b17b4475560"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TEST#41
---

# automation/Catzc.Base.QualityGates/configs/test-policy.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `l4_mutation: {}`.

```text
What a test may do to the environment it reaches ([ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)).

Every key is optional: an omitted key takes the sensible default declared once on
Catzc.Base.QualityGates.TestPolicyConfig
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
```

## comment:2

Above `l4_mutation: {}`.

```text
Per target environment, how far an L4 test (the released system, after final approval) may change it:
  read-only — probes and observations only
  synthetic — transactions the system is built to accept and clean up
An environment not listed is read-only. Example: { pre-prod: synthetic }
```
