# docs/references/automation/catzc-base-execution/Find-Executable.ps1.md

`automation/Catzc.Base.Execution/Find-Executable.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The generic existence check, in two timed steps, from plain inputs:

1. Locate, with no process start: the first of -Candidate that exists wins (Method 'probe'); else the first
   application named -Command on PATH (Method 'path'); else Method 'none'. A path in -Exclude never counts, as
   a candidate or on PATH (for bash on Windows, the WSL launcher). %VAR% environment variables in candidates
   and exclusions are expanded.
2. Confirm: only for a located executable, run it once with -VersionArguments (Get-ExecutableVersion) and
   match its output against -VersionPattern. VersionOk is true when the version starts with -RequiredVersion
   or one of -AcceptVersion (any parsed version, when no version is required).

The version is a lazy session cache entry keyed by the executable's path, its last write time and the
arguments ([ADR-PWSH-CACHE](/docs/adr/pwsh/script-scope-caching.md)), so a process starts at
most once per executable per session, while a reinstall, an upgrade or a removal is seen on the next call. The
locate step runs on every call: it is file checks only.

The caller chooses the candidates for its platform and run environment; Resolve-ToolExecutable does that for a
tools.yml entry. The record carries the session actor (Get-SessionActor), for the report.
```
