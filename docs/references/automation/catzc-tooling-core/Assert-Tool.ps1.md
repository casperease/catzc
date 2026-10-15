---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md
    kind: comment-page
    body_sha: e6e573bf1bbb
---

# automation/Catzc.Tooling.Core/Assert-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Checks that the tool's command is on PATH and that its version
matches the locked version in tools.yml (outside a CI pipeline an optional
devbox_version lever also passes — see Assert-ToolVersion). Does NOT check
DependsOn — those are install-time dependencies, not runtime requirements.
A tool whose entry declares candidate paths is located by the executable probe instead
(Resolve-ToolExecutable): its candidates for this platform and run environment, then PATH.
```

## comment:2

Section `.PARAMETER SkipVersionCheck` of the comment-based help.

```text
Only assert the tool is on PATH. Skip the version match.
Use for operations that need presence but not a specific version
(e.g., uninstalling).
```

## comment:3

Above `if ($config.HasProbes()) {`.

```text
A tool with declared candidate paths is located by the probe, never by its bare name on PATH (for bash on
Windows that name can be the WSL launcher).
```

## comment:4

Above `if ($config.HasProbes()) {`.

```text
A tool with declared candidate paths is located by the probe, never by its bare name on PATH (for bash on
Windows that name can be the WSL launcher).
```
