---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
    kind: comment-page
    body_sha: "77b6354ba2b8"
    adrs: []
---

# automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Resolves the config file for a (template[, customer], environment[, slot]) coordinate —
`infrastructure/templates/<template>/configuration/[<customer>/]<env>[-<slot>].yml` — and sets the
given parameters under `ParametersFile.parameters`. Each entry is written ARM-style as
`{ <name>: { value: <value> } }`.

Idempotent (Set-): an existing config is loaded and the named parameters are overlaid (other
parameters and keys are preserved); a missing config is created (the customer subdir too).
Running it twice with the same input leaves the same file. The config file need not exist yet — that
is how a slot / resource group is added (the next discovery picks it up).

This function does NOT deploy, render, or call Azure. It only edits a file. Deployment of the change
is the CD pipeline's job, against version control.
```

## comment:2

Section `.PARAMETER Environment` of the comment-based help.

```text
Environment name — must be a defined environment in azure.yml (it may be one the template does not
yet have a config for; that is the point of creating the slot).
```

## comment:3

Section `.PARAMETER Customer` of the comment-based help.

```text
Optional customer key (customer.yml) — the config subfolder to write under
(`configuration/<customer>/`). Omitted writes the configuration-root (shared-platform) config. The
coordinate must resolve to exactly one subscription (the same rule discovery enforces).
```

## comment:4

Section `.PARAMETER DryRun` of the comment-based help.

```text
Preview only — returns the planned path and content without writing. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:5

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:6

Above `$loc = if ([string]::IsNullOrEmpty($Customer)) {`.

```text
The coordinate must conform to the conventional tree (the same cross-layer rule discovery
enforces): the customer subfolder is a defined customer key, and the (customer?, env) coordinate
resolves to exactly one subscription.
```
