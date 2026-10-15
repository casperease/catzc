---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
    kind: comment-page
    body_sha: d0d7471f1137
    adrs: []
---

# automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single source of the per-slot parameters artifact name, used by both Build-Bicep (which writes
it) and Get-BicepDeploymentContext (which reads it) so the two can never drift — the same principle
as the derived RG name (Get-BicepResourceGroupName).

`parameters.<config>.json` for a configuration-root (shared-platform) slot, or
`parameters.<customer>.<config>.json` for a customer slot — where `<config>` is `<env>[-<slot>]`
(Get-BicepConfigName). The artifact names mirror the configuration tree exactly: all of a template's
slots render into one build folder, and keying on the customer keeps them structurally
collision-free ((customer?, env, slot) is unique) with no guard to remember. See
[ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
```
