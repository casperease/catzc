# pwsh/Catzc.Base.Execution/Resolve-ToolExecutable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Locates a managed tool's executable from its tools.yml entry and returns the probe record.

### description

The one reading of a tools.yml entry for the existence check, so a caller runs the managed executable by its path and never by a bare name
(`& (Resolve-ToolExecutable -Tool widget).Path`). Test-Tool -PassThru and Assert-Tool return and read the same record.

Reads the entry through Get-Config -Config tools, as a dictionary (reading a config is global access, never guarded by module
dependencies:[ADR-CONF-LOADING-READINGISGLOBAL](../../../adr/configuration/module-config-loading.md#rule-adr-conf-loading-readingisglobal)),
and hands Find-Executable plain inputs:

- the candidates for this platform and run environment (Get-RunEnvironment): windows_probes or unix_probes on a devbox,
  windows_pipeline_probes or unix_pipeline_probes in a pipeline;
- probe_excludes, never counted as the tool (for bash, the WSL launcher);
- the command for the PATH lookup, and the version_command's arguments (its executable token dropped, so the version comes from the located
  file) with version_pattern;
- version as the required prefix and, outside a pipeline, devbox_version as a further accepted one.

### parameter `Tool`

The snake_case tool key as defined in tools.yml.

### outputs

`[Catzc.Base.Execution.ExecutableProbe]`

### example 1

```powershell
(Resolve-ToolExecutable -Tool bash).Path
```

### example 2

```powershell
Resolve-ToolExecutable -Tool go | Select-Object Found, Version, VersionOk
```
