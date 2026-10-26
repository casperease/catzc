# pwsh/Base.QualityGates/private/Write-TestRunContext.ps1

Prints a test run's context block under its banner, one line per fact. It renders the record Get-TestRunContext builds, so a reader sees
what the run is and where it runs before any test output.

## help

### synopsis

Prints a test run's context block under its banner: one line per fact.

### description

Renders Get-TestRunContext's record so a reader sees, before any test output, what the run is and where it runs — the entry point and code
root, the location and why, the tiers asked for and running (and why they differ), who is running it, which local tools are present, and
what is selected:

```text
entry point  Test-Automation · source run · code root C:\repo\automation
location     snapshot (working folder held by Test-Automation, pid 4242)
tiers        asked L0-L3 · running L0-L2 — L3 skipped: snapshot location
actor        Person
tools        git yes · az no · dotnet yes
selection    suite infrastructure; modules: Catzc.Azure.Templates
```

### parameter `Context`

The record Get-TestRunContext returned.

### example 1

```powershell
Write-TestRunContext -Context $context
```
