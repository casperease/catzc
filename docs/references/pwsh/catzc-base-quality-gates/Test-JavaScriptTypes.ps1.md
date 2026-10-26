# pwsh/Base.QualityGates/Test-JavaScriptTypes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:2

Above `$projects = @('jsconfig.json', 'jsconfig.lenient.json')`, written with `#`.

```text
The editor's project and the lenient one beside it; the lenient one holds no file once every module is raised, which tsc reports
as no inputs and the loop below takes as nothing to check.
```

## comment:3

Above `$pattern = '^(?<file>.+?)\((?<line>\d+),(?<column>\d+)\): error...`, written with `#`.

```text
tsc prints one line per error, path(line,col): error TS<number>: message; exit 0 is clean, 1 or 2 is errors, anything
else is tsc failing.
```

## comment:4

Above `$lines = @($check.Output -split '\r?\n')`, written with `#`.

```text
A project left with no files (every module raised out of the lenient one) has nothing to check, which tsc
reports as TS18003.
```
