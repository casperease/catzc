---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-DotnetFormat.ps1.md
    kind: comment-page
    body_sha: acbf860ccb79
    adrs:
      - ADR-PRIN-CONFIG#2
---

# automation/Catzc.Base.QualityGates/private/Invoke-DotnetFormat.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
`dotnet format whitespace --folder` formats by the repository's .editorconfig alone — the same rules the editor's
C# extension applies — with no project to load, so it takes seconds and needs only the .NET SDK. `--verify-no-changes`
with a JSON `--report` names the files that differ; without -DryRun, a second run over exactly those rewrites them.
Exit codes: 0 = clean, 2 = files differ (expected), anything else is a tool error, which throws with the output.

The workspace is the repository root, so a file outside it is not formatted. A changed C# type source changes the
compiled-type cache key, so the next import rebuilds the combined types assembly.
```
