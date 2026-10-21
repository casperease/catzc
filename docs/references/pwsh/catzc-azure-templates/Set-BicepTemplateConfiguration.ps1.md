# pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes (or merges) a template's per-slot ParametersFile into its config file. The write half of the INPUT pipeline: it turns user input into
a version-controlled change, never a runtime cloud mutation.

### description

Resolves the config file for a (template[, customer], environment[, slot]) coordinate —
`infrastructure/templates/<template>/configuration/[<customer>/]<env>[-<slot>].yml` — and sets the given parameters under
`ParametersFile.parameters`. Each entry is written ARM-style as `{ <name>: { value: <value> } }`.

Idempotent (Set-): an existing config is loaded and the named parameters are overlaid (other parameters and keys are preserved); a missing
config is created (the customer subdir too). Running it twice with the same input leaves the same file. The config file need not exist yet —
that is how a slot / resource group is added (the next discovery picks it up).

This function does NOT deploy, render, or call Azure. It only edits a file. Deployment of the change is the CD pipeline's job, against
version control.

It rests on [ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md) and [FDR-CD-TYPE](../../../drs/flow/pipeline-types.md).

### parameter `Template`

Template name (folder under infrastructure/templates/).

### parameter `Environment`

Environment name — must be a defined environment in azure.yml (it may be one the template does not yet have a config for; that is the point
of creating the slot).

### parameter `Parameters`

Hashtable of ARM parameter name -> value. Each becomes `parameters.<name>.value = <value>`.

### parameter `Slot`

Optional special-slot discriminator (1-3 lowercase alphanumeric). Omitted ⇒ the base / index-0 slot.

### parameter `Customer`

Optional customer key (customer.yml) — the config subfolder to write under (`configuration/<customer>/`). Omitted writes the
configuration-root (shared-platform) config. The coordinate must resolve to exactly one subscription (the same rule discovery enforces).

### parameter `DryRun`

Preview only — returns the planned path and content without writing. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### example 1

```powershell
Set-BicepTemplateConfiguration discovery dev -Parameters @{ sqlAdminLogin = 'admin' }
```

### example 2

```powershell
Set-BicepTemplateConfiguration discovery dev -Customer apex -Parameters @{ sqlAdminLogin = 'admin' } -DryRun
```

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`, written with `#`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/drs/automation/dry-run.md).
```

## comment:2

Above `$loc = if ([string]::IsNullOrEmpty($Customer)) {`, written with `#`.

```text
The coordinate must conform to the conventional tree (the same cross-layer rule discovery
enforces): the customer subfolder is a defined customer key, and the (customer?, env) coordinate
resolves to exactly one subscription.
```
