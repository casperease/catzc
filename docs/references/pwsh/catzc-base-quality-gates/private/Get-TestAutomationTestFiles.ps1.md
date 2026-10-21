# pwsh/Catzc.Base.QualityGates/private/Get-TestAutomationTestFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists a run's test files, path by path in the given order, each tests folder's files in ordinal order.

### description

The work-list behind Test-Automation's phases: every `*.Tests.ps1` under each tests/ folder (recursing, so tests/types/ is included), in the
paths' foundation-first order (Get-TestAutomationTestPaths) and, within a folder, ordinal-sorted so the list is the same on every machine. A
Go or Python test folder (Get-LanguageTestFolders) is one run file itself: the language bridge runs it as one unit
(ConvertTo-PesterRunTarget). Throws when the paths hold no test file — a run with nothing to run is a scoping mistake, never a green.

### parameter `TestPath`

The run's tests/ folders and language test folders, in run order.

### outputs

`[string[]]` absolute test-file paths, and language test folder paths.

### example 1

```powershell
$testFiles = Get-TestAutomationTestFiles -TestPath $testPaths
```
