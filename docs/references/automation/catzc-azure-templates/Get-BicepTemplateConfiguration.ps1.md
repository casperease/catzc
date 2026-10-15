---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
    kind: comment-page
    body_sha: cc30d213f793
    adrs: []
---

# automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns the parsed yml as an ordered dictionary — typically just a `ParametersFile` (the
template's ARM parameters, written statically). No merge with global config happens here;
PrePost's Invoke-BicepPrepareParameterSet is the merge seam. The resource-group name is not
read from this file — it is derived by Get-BicepResourceGroupName.

The config address is literal ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): a configuration-root file
`configuration/<env>[-<slot>].yml` (the shared-platform deployment), or a customer's file
`configuration/<customer>/<env>[-<slot>].yml` when -Customer is given. No resolution machinery —
the coordinate IS the file.
```

## comment:2

Section `.PARAMETER Slot` of the comment-based help.

```text
Optional special-slot discriminator — 1-3 lowercase alphanumeric chars (`001`, `blu`, …). Selects
`<env>-<slot>.yml`; omitted selects the env's base slot `<env>.yml`. The selected config must exist.
```

## comment:3

Section `.PARAMETER Customer` of the comment-based help.

```text
Optional customer key (a configuration subfolder). Selects the config under
`configuration/<customer>/`; omitted selects the configuration-root (shared-platform) config.
```

## comment:4

Above `$configName = Get-BicepConfigName $Environment $Slot`.

```text
One config file per (customer?, env, slot): the coordinate is the file address — root for the
shared platform, configuration/<customer>/ for a customer deployment.
```
