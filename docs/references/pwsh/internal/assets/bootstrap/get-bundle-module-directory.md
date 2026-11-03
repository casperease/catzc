# pwsh/.internal/assets/bootstrap/Get-BundleModuleDirectory.ps1

The bundle half of the module enumeration: a bundle load takes its pwsh modules from the bundle record, never from the folders it finds,
since a language module sits under the same code root at its track's place
([ADR-AUTO-BUNDLE-EVERYLANGUAGE](../../../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-everylanguage)). `Import-AllModules`
calls it in a bundle load only; source mode enumerates the folders.

## help

### synopsis

Returns the module folders under a bundle's code root that the bundle record's `modules` list names.

### description

Reads `build.json` at the code root and returns, one level down, each folder whose name is a recorded module. A folder the record does not
name, such as a language place, is never returned, and a recorded module with no folder is not reported here, since the bundle self-check
owns that comparison. A code root without `build.json` throws.

### parameter `ModulesRoot`

The bundle's code root, where `build.json` and the module folders sit.
