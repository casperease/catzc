# pwsh/Azure.Templates/Build-Bicep.ps1

The command that builds a bicep template: it renders the per-slot parameter files and compiles `main.bicep`.

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

Before the slots render, copies `main.bicep` and every file it reaches (modules, imports, loaded files and the `bicepconfig.json` between
them) into `<out>/bicep/`, keeping their layout, so the output folder is self-contained. Then runs
`bicep build <copied main.bicep> --outdir <out>` once for the template, producing `main.json`. Finally copies the per-template
`PrePost.psm1` (if any) and the contents of `resources/` (if any) into the output folder.

The output folder, `-OutputFolder` or the template's `out/template/<name>`, is wiped and recreated on every call and returned.

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

### parameter `RuntimeSlots`

Ephemeral slots to build too, as `<env>-<slot>`: each on every selected base slot of that environment, with no file of its own.

### parameter `RuntimeSlotsJson`

The same, as a pipeline's deploy-target list in JSON (`[{ env, slot?, ... }]`): every entry with a slot is a runtime slot.

### parameter `OutputFolder`

The folder to build into, wiped first. Defaults to the template's `out/template/<name>`, the folder the pipelines publish and the deploy
reads; a reader that only inspects the build (a gate, a test) passes a folder of its own, so a concurrent build of the same template never
swaps the files it reads.

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

## Which slots

Every slot is built by default. `-Environments` narrows by environment, and `-Customers` and `-Shared` narrow by the configuration axis (a
customer's subfolder slots, or the root slots), unioned when both are given.

## Precondition

The bicep binary must be installed at the `tools.yml` pin before the output is wiped and the parameters are rendered. The command resolves
it once (`Resolve-ToolExecutable -Tool bicep`) and runs every compile through that path, so no compile pays az's Python start or a version
probe; a missing or older binary throws, naming `Install-Bicep`.

## The PrePost hook

A template may ship its own `infrastructure/templates/<name>/PrePost.psm1` that exports a build-time `Invoke-BicepPrepareParameterSet` hook.
The command resolves it once when present, and when it is absent the prepare step does nothing and the per-slot configuration is used
unchanged. The `assets/PrePost.psm1` starter is never loaded here, since it exists only to be copied into a template.

The hooks run strict like every catzc module, whoever wrote them
([ADR-PWSH-ERROR-STRICTCLEAN](../../../drs/automation/pwsh/error-handling.md#rule-adr-pwsh-error-strictclean)).

Hooks read what they need from the build invocation, the arguments `Build-Bicep` is acting on for the slot (for example
`$BuildInvocation.Customer`), rather than from raw parameters, so adding a dimension never changes the hook signature
([ADR-PWSH-PREPOST](../../../drs/automation/pwsh/prepost-extension-modules.md)).

## Parameters

A config-addressed parameter `{ address: global.<config>.<key> }` renders as the value it addresses
([ADR-AZ-DATAMOD-VALUEBYADDRESS](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress)) before the PrePost hook runs,
so the hook and the parameters file see only ARM entries.

The `UNDEFINED` marker is a string and is compared string-first and case-sensitively. A boolean `true`, which `-eq` coerces to equal any
non-empty string, or a number therefore never reads as undefined.

Every slot reaches the deploy one way (ADR-AZ-DATAMOD-ONEPATHTOPARAMETERS): a `.bicepparam` in the output folder, compiled by
`bicep build-params`, whose `using` names the copy of `main.bicep` inside the output folder. Every path a built `.bicep` or `.bicepparam`
file names resolves inside the output folder, never to the source tree, so the folder is valid alone and never goes stale against a later
edit of the template.

## The compiled template

`bicep build` can exit 0 yet emit nothing, so the command asserts the compiled `main.json` at the source. The failure then names the real
culprit here, not later as a generic missing file in `Get-BicepDeploymentContext`. The Bicep CLI was proved available above, so a missing
`main.json` is an unexpected build failure and not a missing install, and the message says exactly that.
