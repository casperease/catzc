# pwsh/Base.QualityGates/private/Get-TestRunNothingToRunMessage.ps1

Words the stop line of a run that has no work. An empty selection and a work-list that protection drained are different causes, and the
message names which one it is.

## help

### synopsis

The message of a test run that finds nothing to run.

### description

When no test file is selected the message names the tier range that held no test. When files were selected but every module in scope is
protected, it says so instead.

### parameter `TestFileCount`

The number of test files the selection found before protection was applied.

### parameter `MinLevel`

The lowest test tier in the run's scope.

### parameter `MaxLevel`

The highest test tier in the run's scope.

### outputs

`[string]` the message.
