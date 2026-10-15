---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunContext.ps1.md
    kind: comment-page
    body_sha: "5a1a1a60b1f6"
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestRunContext.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One record of the run's context, for the console block under the banner (Write-TestRunContext) and for
run.json, so a reader of either knows what ran without inferring it:

- entryPoint, run (source | build), and codeRoot — the modules the workers load (the build's own automation/
  folder for a build run, Get-CatzcModulesRoot otherwise);
- location (in-place | snapshot, the location's Mode) and locationReason — who held the working folder, or
  -Isolated;
- tiersRequested, tiersRunning, and tierCap — why the top tier is lower than asked (Resolve-TestRunMaxLevel);
- actor — Pipeline, Agent, or Person (Get-SessionActor);
- tools — whether git, az, and dotnet are on the PATH (found with Get-Command; no process is started);
- selection — all tests, a test suite, the modules, the category, and the -Rule filter.
```
