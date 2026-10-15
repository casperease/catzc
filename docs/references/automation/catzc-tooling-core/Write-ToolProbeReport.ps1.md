---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Write-ToolProbeReport.ps1.md
    kind: comment-page
    body_sha: "2641df39c91b"
    adrs:
      - ADR-PWSH-ANNOUNCE#7
---

# automation/Catzc.Tooling.Core/Write-ToolProbeReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Renders the probe records from Test-Tool -PassThru as one plain-text table through Write-Message -NoHeader
([ADR-PWSH-ANNOUNCE#7](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce7)): one
row per tool with Found, Method (probe | path | none), Version against Required, VersionOk, ProbeMs and
VersionMs, then the path. The header line names the session actor the checks ran as. Writes
nothing for no records. With no -Probe it checks every tool in tools.yml.
```

## comment:2

Section `.PARAMETER Probe` of the comment-based help.

```text
The probe records to render (Catzc.Base.Execution.ExecutableProbe, from Test-Tool -PassThru or
Resolve-ToolExecutable). Accepts pipeline input. Defaults to every tool in tools.yml.
```
