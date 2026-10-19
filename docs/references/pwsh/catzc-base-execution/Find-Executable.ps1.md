# pwsh/Catzc.Base.Execution/Find-Executable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Locates an executable without starting a process, then confirms its version once per session.

### description

The generic existence check, in two timed steps, from plain inputs:

1. Locate, with no process start: the first of -Candidate that exists wins (Method 'probe'); else the first application named -Command on
   PATH (Method 'path'); else Method 'none'. A path in -Exclude never counts, as a candidate or on PATH (for bash on Windows, the WSL
   launcher). %VAR% environment variables in candidates and exclusions are expanded.
2. Confirm: only for a located executable, run it once with -VersionArguments (Get-ExecutableVersion) and match its output against
   -VersionPattern. VersionOk is true when the version starts with -RequiredVersion or one of -AcceptVersion (any parsed version, when no
   version is required).

The version is a lazy session cache entry keyed by the executable's path, its last write time and the arguments
([ADR-PWSH-CACHE](../../../adr/automation/pwsh/script-scope-caching.md)), so a process starts at most once per executable per session, while a
reinstall, an upgrade or a removal is seen on the next call. The locate step runs on every call: it is file checks only.

The caller chooses the candidates for its platform and run environment; Resolve-ToolExecutable does that for a tools.yml entry. The record
carries the session actor (Get-SessionActor), for the report.

### parameter `Name`

The name the record carries (a tools.yml key, for a tool).

### parameter `Command`

The command name looked up on PATH when no candidate exists. Defaults to -Name.

### parameter `Candidate`

The candidate executable paths, in order. Empty for a PATH-only lookup.

### parameter `Exclude`

Executable paths that never count, as a candidate or on PATH.

### parameter `VersionArguments`

The arguments that make the executable print its version (e.g. '--version').

### parameter `VersionPattern`

The regex that captures the version as the named group (`?<ver>`...).

### parameter `RequiredVersion`

The version prefix the reported version must start with. Empty accepts any parsed version.

### parameter `AcceptVersion`

Further version prefixes that also satisfy the check (for a tool, the devbox_version lever outside a pipeline).

### outputs

`[Catzc.Base.Execution.ExecutableProbe]`

### example 1

```powershell
Find-Executable -Name 'widget' -Candidate '%LOCALAPPDATA%\Widget\widget.exe' -VersionArguments '--version' -VersionPattern 'widget (?<ver>[\d.]+)' -RequiredVersion '5'
```

### example 2

```powershell
(Find-Executable -Name 'gadget' -VersionArguments 'version' -VersionPattern 'v(?<ver>[\d.]+)').Path
```
