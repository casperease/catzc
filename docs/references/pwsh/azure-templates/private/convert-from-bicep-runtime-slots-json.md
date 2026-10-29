# pwsh/Azure.Templates/private/ConvertFrom-BicepRuntimeSlotsJson.ps1

A private helper of the Bicep build. It turns a pipeline's deploy-target list into the names of the ephemeral slots the build must derive.

## help

### synopsis

Names the runtime slots in a deploy-target list as `<env>-<slot>`.

### description

Parses the JSON list a pipeline passes (`[{ env, slot?, ... }]`, as convertToJson writes it). An entry with a slot is an ephemeral slot on
its base slot and yields `<env>-<slot>`; an entry without one is a base slot, built from its file, and yields nothing. An empty or blank
string yields nothing. An entry that is not a dictionary or has no `env` throws.

Private helper of the Bicep build; not exported.

### parameter `Json`

The pipeline's deploy-target list as JSON. May be empty.

### outputs

`[string]` One slot name per runtime slot entry.

### example 1

```powershell
ConvertFrom-BicepRuntimeSlotsJson -Json '[{"env":"dev","slot":"pr42"},{"env":"test"}]'
```
