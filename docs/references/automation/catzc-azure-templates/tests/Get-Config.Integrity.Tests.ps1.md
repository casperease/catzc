---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-Config.Integrity.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6db24447c9bc"
---

# automation/Catzc.Azure.Templates/tests/Get-Config.Integrity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Shipped asset integrity' -Tag 'L0', 'integrity' {`, written with `#`.

```text
Integrity tests for the SHIPPED config assets + real templates. Unlike the logic unit tests, these
deliberately bind to the real configs/azure.yml, configs/network.yml, and infrastructure/templates/ —
they are the contract that "what ships is internally consistent". They do NOT mock the
Resolve-ConfigEntry (config discovery) / Get-BicepTemplatesRoot seams. Nothing else depends on them.
```

## comment:2

Above `$violations = foreach ($t in (Get-BicepTemplates)) {`, written with `#`.

```text
One Should over the violating set — a Should per template slot pays Pester's per-assertion
cost times the whole discovered template tree.
```

## comment:3

Above `try {`, written with `#`.

```text
slot.customer is the raw token from the subscription (a key or shortcode); it must
resolve to a defined customer in customer.yml (Get-AzureCustomer throws otherwise).
```
