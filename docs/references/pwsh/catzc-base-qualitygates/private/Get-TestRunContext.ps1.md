# automation/Catzc.Base.QualityGates/private/Get-TestRunContext.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Collects the facts that say what a test run is and where it runs: its context block.

### description

One record of the run's context, for the console block under the banner (Write-TestRunContext) and for run.json, so a reader of either knows
what ran without inferring it:

- entryPoint, run (source | build), and codeRoot — the modules the workers load (the build's own automation/ folder for a build run,
  Get-CatzcModulesRoot otherwise);
- location (in-place | snapshot, the location's Mode) and locationReason — who held the working folder, or -Isolated;
- tiersRequested, tiersRunning, and tierCap — why the top tier is lower than asked (Resolve-TestRunMaxLevel);
- actor — Pipeline, Agent, or Person (Get-SessionActor);
- tools — whether git, az, and dotnet are on the PATH (found with Get-Command; no process is started);
- selection — all tests, a test suite, the modules, the category, and the -Rule filter.

### parameter `EntryPoint`

The entry point's command name.

### parameter `EntryScript`

The script the workers dot-source; empty is the source importer.

### parameter `Location`

The location Enter-TestRunLocation returned.

### parameter `MinLevel`

The run's lowest tier.

### parameter `RequestedMaxLevel`

The highest tier the caller asked for.

### parameter `MaxLevel`

The highest tier the run executes (after Resolve-TestRunMaxLevel).

### parameter `Category`

The category filter.

### parameter `Modules`

The modules in scope; empty is every module.

### parameter `Suite`

A test suite's name, when the modules were resolved from one; otherwise empty.

### parameter `Rule`

The -Rule filter.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` the context, keyed as run.json records it.

### example 1

```powershell
Get-TestRunContext -EntryPoint Test-Automation -Location $location -RequestedMaxLevel 3 -MaxLevel 2
```
