---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md
    kind: comment-page
    body_sha: "4dd7bdd33bca"
---

# automation/Catzc.Tooling.Core/Test-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns $true if the tool's command exists, its version command produces parseable output, AND the installed
version matches the locked version in tools.yml. Returns $false for missing tools, Windows Store stubs, broken
installations, and version mismatches.

A tool whose entry declares candidate paths (windows_probes, unix_probes and their pipeline lists, or
probe_excludes) is located by the executable probe (Resolve-ToolExecutable, in Catzc.Base.Execution): the
candidates for this platform and run environment first, then PATH, with no process start; its version runs once
per executable per session. Any other tool is checked by its command name on PATH.
```

## comment:2

Section `.PARAMETER SkipVersionCheck` of the comment-based help.

```text
Only test the tool is on PATH and functional. Skip the version match.
Use for operations that need presence but not a specific version
(e.g., uninstalling).
```

## comment:3

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the probe record (Catzc.Base.Execution.ExecutableProbe: Name, Found, Path, Method, Version, Required,
VersionOk, ProbeMs, VersionMs, Actor) instead of a boolean, for any tool. Write-ToolProbeReport renders it.
```

## comment:4

Above `if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {`.

```text
Devbox lever (mirrors Assert-ToolVersion): outside a CI pipeline, also accept an installed version
matching the tool's devbox_version prefix, so a levered off-pin tool reads as usable for quality gates
too — not just runtime asserts.
```

## comment:5

Above `if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {`.

```text
Devbox lever (mirrors Assert-ToolVersion): outside a CI pipeline, also accept an installed version
matching the tool's devbox_version prefix, so a levered off-pin tool reads as usable for quality gates
too — not just runtime asserts.
```
