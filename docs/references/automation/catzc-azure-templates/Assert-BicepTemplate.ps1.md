---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1cff1a11cd39"
    adrs:
      - ADR-AZ-DATAMOD#9
---

# automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$folders = @([System.IO.Directory]::EnumerateDirectories($root) | Sort-Object)`, written with `#`.

```text
[System.IO.Directory] (sorted) instead of Get-ChildItem — see Get-BicepTemplates for the
~20ms-per-call Get-ChildItem overhead this avoids.
```

## comment:2

Above `$customerDeploymentOption = if ($options.Contains('customer_deployment')) {`, written with `#`.

```text
Customer-class bit — defaults to the have_customers variant unless options.yml sets it; an explicit
customer_deployment: true is only allowed when customers are enabled (see customer-model ADR).
```

## comment:3

Above `$shortNameOverride = if ($options.Contains('short_name')) {`, written with `#`.

```text
short_name is derived from the folder name unless options.yml overrides it. BicepShortName owns the
derivation + format validation (throws on a malformed override, or a folder that cannot derive a
valid short_name without one); the resolved value feeds the global-uniqueness check.
```

## comment:4

Above `$built = $false`, written with `#`.

```text
The full build (render + compile) so the rendered parameters files can be checked against the
compiled parameter model ([ADR-AZ-DATAMOD#9](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9)).
```
