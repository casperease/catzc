# automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes the opening banner for a Test-Automation run — the framed header that brackets the run's output.

### description

Renders a single Write-Header (a self-contained curved box) naming the run's scope: its tier range, plus the category and the module list
when either is narrowed from the defaults. Test-Automation calls this before it sets the writers' suppression flag, so the banner renders
and everything the run then emits — Pester's own lines, and the timing / report / skip sections below — sits under it.

### parameter MinLevel

The run's minimum tier (0-3), as Test-Automation resolved it.

### parameter MaxLevel

The run's maximum tier (0-3).

### parameter Category

The run's category filter (Logic / Integrity / Both); named in the scope only when it is not Both.

### parameter Modules

The modules the run was scoped to; named in the scope only when non-empty.

### parameter Title

The run's name on the banner: "Test Automation" (the source run, the default) or the build run's "Catzc Build Run"
([ADR-AUTO-TEST#30](../../../../adr/automation/test-automation.md#rule-adr-auto-test30)).
