# pwsh/Base.QualityGates/Test-JavaScriptTypes.ps1

The type check for the repository's JavaScript: it runs `tsc` over the jsconfig projects and writes a report to the output folder.

## help

### synopsis

Type-checks the repository's JavaScript with tsc and writes a report to the output folder.

### description

Runs the managed TypeScript compiler (`tsc --noEmit`) over the two root projects, jsconfig.json and jsconfig.lenient.json, which
Build-RootConfig renders. A quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): every
`<file>(<line>,<column>): error TS<n>` line is an issue, written repository-relative, and the gate ends through Write-QualityGateReport.
-PassThru returns the result object instead. A project tsc reports as having no inputs (error TS18003) is nothing to check. A tsc exit that
is not 0, 1 or 2, or a failing exit with no parsable error line, throws: there is no verdict to report. A missing project file or a missing
tsc throws first, naming the command that fixes it.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-javascript-types`.

### parameter `PassThru`

Return a result object instead of throwing.

### example 1

```powershell
Test-JavaScriptTypes -PassThru
```

## Projects

The command checks the editor's project, `jsconfig.json`, and the lenient one beside it, `jsconfig.lenient.json`. Once every module is
raised out of the lenient one, it holds no file, and `tsc` reports that as TS18003 (no inputs). The loop takes that as nothing to check.

## Reading tsc

`tsc` prints one line per error, `path(line,col): error TS<number>: message`. Exit 0 is clean, 1 or 2 means errors, and anything else is
`tsc` failing.
