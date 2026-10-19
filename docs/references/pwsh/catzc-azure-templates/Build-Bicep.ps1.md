# pwsh/Catzc.Azure.Templates/Build-Bicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds a bicep template: renders per-slot parameter files and compiles main.bicep.

### description

For each target slot (one per `configuration/[<customer>/]<config>.yml`):

1. Loads the slot's config via Get-BicepTemplateConfiguration.
2. Runs the UNDEFINED guard (throws if any flattened leaf is the literal string 'UNDEFINED').
3. Resolves every config-addressed parameter, `{ address: global.<config>.<key>… }`, into `{ value: … }` through Get-ConfigValue
   (Resolve-BicepParameterAddresses). An address reaches only version-controlled config, so no secret can be addressed: a secure parameter
   takes a Key Vault `reference`. An address that does not resolve, or one set together with `value` or `reference`, fails the build, naming
   the config file and the parameter.
4. If the template ships `infrastructure/templates/<name>/PrePost.psm1` exporting Invoke-BicepPrepareParameterSet, runs it — the merge seam
   between per-slot config and the global asset configs in `Catzc.Azure.Templates/assets/*.yml`. With no such hook the step is a no-op (the
   per-slot config is used unchanged).
5. Renders the resulting `.ParametersFile` to `out/template/<name>/parameters.[<customer>.]<config>.json` — one per config file; the name
   comes from Get-BicepParametersFileName (config name = `<env>[-<slot>]`).

Then runs `az bicep build --file <main.bicep> --outdir <out>` once for the template, producing `main.json`. Finally copies the per-template
`PrePost.psm1` (if any) and the contents of `resources/` (if any) into the output folder.

The output folder is wiped and recreated on every call.

### parameter `Template`

Template name (folder under infrastructure/templates/).

### parameter `Environments`

Optional filter — build only slots whose environment is named here. Defaults to all slots configured for the template (one parameters file
per `configuration/*.yml`, excluding default).

### parameter `Customers`

Optional filter — build only the named customers' slots (their configuration subfolders).

### parameter `Shared`

Optional filter — build the configuration-root (shared-platform, non-customer) slots. Combines with -Customers as a union; with neither
filter every slot builds.

### example 1

```powershell
Build-Bicep discovery
```

### example 2

```powershell
Build-Bicep discovery -Environments dev
```

### example 3

```powershell
Build-Bicep discovery -Customers apex
```

### example 4

```powershell
Build-Bicep foundation -Shared
```

## comment:1

Above `$targetSlots = @($templateDescriptor.slots)`, written with `#`.

```text
Build every slot by default; -Environments narrows by env, and -Customers/-Shared narrow by the
configuration axis (a customer's subfolder slots / the root slots), unioned when both are given.
```

## comment:2

Above `Assert-AzCliBicep`, written with `#`.

```text
Precondition: the Bicep CLI must be available before we wipe the output and render params, else
`az bicep build` can exit 0 while writing no main.json (e.g. a missing/blocked auto-install). This
also warms the install in its own call, separate from the build. See Assert-AzCliBicep.
```

## comment:3

Above `$prepareHook = $null`, written with `#`.

```text
A template MAY ship its own infrastructure/templates/<name>/PrePost.psm1 exporting a build-time
Invoke-BicepPrepareParameterSet hook. Resolve it once if present; absent -> the prepare step
is a no-op (the per-slot config is used unchanged). The assets/PrePost.psm1 starter is never
loaded here — it exists only to be copied into a template.
```

## comment:4

Above `. $prepostModule { Set-StrictMode -Version Latest }`, written with `#`.

```text
The template's hooks run strict like every catzc module, whoever wrote them
([ADR-PWSH-ERROR-STRICTCLEAN](/docs/adr/automation/pwsh/error-handling.md#rule-adr-pwsh-error-strictclean)).
```

## comment:5

Above `if ($flat[$key] -is [string] -and 'UNDEFINED' -ceq $flat[$key]) {`, written with `#`.

```text
The marker is a string: compared string-first and case-sensitively, so a boolean `true` (which -eq coerces to
equal any non-empty string) or a number never reads as undefined.
```

## comment:6

Above `if ($configurationDescriptor.Contains('ParametersFile') -and...`, written with `#`.

```text
A config-addressed parameter `{ address: global.<config>.<key>… }` renders as the value it addresses
([ADR-AZ-DATAMOD-VALUEBYADDRESS](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress)), before the PrePost hook,
so the hook and the parameters file see only ARM entries.
```

## comment:7

Above `$buildInvocation = [ordered]@{`, written with `#`.

```text
The build invocation for this slot — the arguments Build-Bicep is acting on. Hooks read what
they need from it (e.g. $BuildInvocation.Customer) rather than via raw params, so adding a
dimension never changes the hook signature.
See [ADR-PWSH-PREPOST](/docs/adr/automation/pwsh/prepost-extension-modules.md).
```

## comment:8

Above `$mainJson = Join-Path $outputFolder 'main.json'`, written with `#`.

```text
az bicep build can exit 0 yet emit nothing. Assert the compiled template at the source so the
failure names the real culprit here, not later as a generic missing-file in
Get-BicepDeploymentContext. Assert-AzCliBicep already proved the Bicep CLI is available above, so a
missing main.json now is an unexpected build failure, not a not-installed one — say exactly that.
```
