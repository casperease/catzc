# pwsh/Catzc.Base.QualityGates/configs/test-policy.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `l4_mutation: {}`, written with `#`.

```text
What a test may do to the environment it reaches ([ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)).

Every key is optional: an omitted key takes the sensible default declared once on
Catzc.Base.QualityGates.TestPolicyConfig
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
```

## comment:2

Above `l4_mutation: {}`, written with `#`.

```text
Per target environment, how far an L4 test (the released system, after final approval) may change it:
  read-only — probes and observations only
  synthetic — transactions the system is built to accept and clean up
An environment not listed is read-only. Example: { pre-prod: synthetic }
```
