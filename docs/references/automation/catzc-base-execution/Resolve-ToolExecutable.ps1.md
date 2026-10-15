# docs/references/automation/catzc-base-execution/Resolve-ToolExecutable.ps1.md

`automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one reading of a tools.yml entry for the existence check, so a caller runs the managed executable by its
path and never by a bare name (`& (Resolve-ToolExecutable -Tool widget).Path`). Test-Tool -PassThru and
Assert-Tool return and read the same record.

Reads the entry through Get-Config -Config tools, as a dictionary (reading a config is global access, never
guarded by module dependencies:[ADR-CONF-LOADING#6](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading6)),
and hands Find-Executable plain inputs:

- the candidates for this platform and run environment (Get-RunEnvironment): windows_probes or unix_probes
  on a devbox, windows_pipeline_probes or unix_pipeline_probes in a pipeline;
- probe_excludes, never counted as the tool (for bash, the WSL launcher);
- the command for the PATH lookup, and the version_command's arguments (its executable token dropped, so the
  version comes from the located file) with version_pattern;
- version as the required prefix and, outside a pipeline, devbox_version as a further accepted one.
```
