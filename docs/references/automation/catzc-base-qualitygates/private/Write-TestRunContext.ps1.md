# docs/references/automation/catzc-base-qualitygates/private/Write-TestRunContext.ps1.md

`automation/Catzc.Base.QualityGates/private/Write-TestRunContext.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Renders Get-TestRunContext's record so a reader sees, before any test output, what the run is and where it
runs — the entry point and code root, the location and why, the tiers asked for and running (and why they
differ), who is running it, which local tools are present, and what is selected:

    entry point  Test-Automation · source run · code root C:\repo\automation
    location     snapshot (working folder held by Test-Automation, pid 4242)
    tiers        asked L0-L3 · running L0-L2 — L3 skipped: snapshot location
    actor        Person
    tools        git yes · az no · dotnet yes
    selection    suite infrastructure; modules: Catzc.Azure.Templates
```
