# automation/.scriptanalyzer/NoRawPipelineDetection.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Whether code is running inside a CI/CD pipeline is detected by checking the
agent-set environment variables TF_BUILD (Azure DevOps) and GITHUB_ACTIONS
(GitHub Actions). That detection logic must live in exactly one place —
Test-IsRunningInPipeline — so the checked variables stay an implementation
detail and both platforms are always covered.

This rule flags any direct reference to $env:TF_BUILD or $env:GITHUB_ACTIONS
that appears OUTSIDE the function Test-IsRunningInPipeline. The canonical
detector is the one sanctioned place that reads them, so it is exempt.

Test files (*.Tests.ps1) are exempt: they legitimately set and restore these
variables to drive Test-IsRunningInPipeline through both contexts in isolation.

Note: $env:BUILD_ARTIFACTSTAGINGDIRECTORY is deliberately NOT flagged — it
answers "where does output go," not "am I in a pipeline," and its read is
confined to Get-OutputRoot.

See ADR: [ADR-FLOW-CD-DETECT#1](/docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1).
```

## comment:2

Above `$isVariable = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
