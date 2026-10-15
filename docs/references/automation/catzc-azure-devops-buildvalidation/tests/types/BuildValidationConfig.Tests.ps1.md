---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "7d3fce1a0c79"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AZ-CUSTOMER#3
---

# automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'BuildValidationConfig' -Tag 'L0', 'logic' {`.

```text
The build-validation.yml type (collect-all-then-throw), plus the shipped-config integrity check: every entry
ties to a declared globset and resolves a pipeline (the
[ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3) pattern — the cross-config
reference is enforced here and at runtime, never at config load).
```

## comment:2

Above `$script:valid = [ordered]@{`.

```text
Neutral fixture globset/pipeline names (widget/gadget) — the type checks SHAPE only (globset existence
is enforced by the integrity test below and at runtime), so a logic fixture must not borrow real
deployable-unit names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
