# automation/Catzc.Base.QualityGates/Test-Formatting.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks that formatting would leave the repository unchanged.

### description

One gate for every formatter's check ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)).
It keeps no list of formatters of its own: Format-Code -DryRun runs every engine the file-language registry
(languages.yml) names, over every tracked file of each language, and every file an engine would change is one
issue naming the file and the command that fixes it
([ADR-PRIN-CONFIG#1](../../../adr/principles/configure-not-program.md#rule-adr-prin-config1)).

The C# file-scoped namespace is a repository content rule rather than a layout engine, so it is checked beside
the engines: Format-Types -DryRun names every type source whose namespace is missing or wrong, and every
block-scoped one, which needs a hand edit. It runs with the csharp language — on the full run, or when -Language
names csharp.

Collects every issue and ends with Write-QualityGateReport: the report lands in out/test-formatting/, and the gate
throws once listing every issue (or returns the result with -PassThru). An engine whose tool is missing throws
with the command that installs it. The scope is the source tree, so the gate needs the source mode
(Assert-SourceTree).

### parameter Language

Check only these file languages (default: every one).

### parameter OutputFolder

The report base folder. Defaults to Write-QualityGateReport's (out/test-formatting).

### parameter PassThru

Return the gate result { Subject; IssueCount; Issues; ReportPath; Languages } instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-Formatting
```

### example 2

```powershell
(Test-Formatting -Language pipeline-yaml -PassThru).Issues
```
