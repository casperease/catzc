# pwsh/Azure.Templates/private/Read-BicepTemplateOptions.ps1

The private function that reads a template's optional `options.yml` and returns the validated deployment overrides.

## help

### synopsis

Reads a template's optional `options.yml` and returns the validated deployment overrides.

### description

Each template folder under `infrastructure/templates/<name>/` MAY carry an `options.yml` beside `main.bicep` declaring how the template
deploys:

```text
short_name: smpl                  # 2-5 lowercase alnum — OVERRIDES the folder-derived Azure id segment
deployment_mode: Incremental      # Incremental | Complete | DoNotRun
deployment_target: Subscription   # ResourceGroup | Subscription
environment_kind: subscription    # standard | subscription
customer_deployment: true         # bool — is this a customer template? (defaults to the have_customers variant)
```

Every key is OPTIONAL — the file itself is optional (Read-BicepTemplateOptions just validates what is present). `short_name` here is a pure
OVERRIDE: with no options.yml (or no `short_name` key) the template's short_name is DERIVED from its folder name by `Get-BicepTemplates`
(`[BicepShortName]::Resolve`) and checked for global uniqueness. An absent file (or an absent key) leaves the caller's default in place;
`Get-BicepTemplates` overlays the returned keys onto each template's descriptor, replacing the hardcoded `Incremental` / `ResourceGroup`
defaults.

The schema is STRICT: any key other than the allowed set (`short_name` / `deployment_mode` / `deployment_target` / `environment_kind` /
`customer_deployment`), or any value outside the matching enum / format / type, throws — so a typo fails fast at discovery time rather than
silently doing nothing.

Returns an ordered dictionary containing ONLY the keys present in the file (empty when the file is absent or carries no recognised keys).

### parameter `TemplateFolder`

Absolute path to the template folder (the one containing `main.bicep`).

### example 1

```powershell
Read-BicepTemplateOptions 'C:\repo\infrastructure\templates\sample-subscription'
# -> [ordered]@{ deployment_target = 'Subscription' }
```

## comment:1

Above `if ($options.Contains('facts')) {`, written with `#`.

```text
A fact is a boolean field of the azure.yml environment record, read from the type so the record stays the one list of them, or
policy_enforcement, the enforcement mode of the subscription the slot targets.
```
