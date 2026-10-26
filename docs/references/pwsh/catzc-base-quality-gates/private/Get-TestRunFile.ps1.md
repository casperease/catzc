# pwsh/Base.QualityGates/private/Get-TestRunFile.ps1

Names the run file a discovered or executed Pester test belongs to: its test file, or its language test folder. The harness schedules,
scopes, protects and reports by run file, the unit a shard runs.

## help

### synopsis

Names the run file a discovered or executed Pester test belongs to: its test file, or its language test folder.

### description

The harness schedules, scopes, protects, and reports by run file — the unit a shard runs. For a `*.Tests.ps1` test that is its file. A
language bridge test (tests/Language.Bridge.ps1, run once per Go or Python test folder as a Pester container whose data names the folder)
belongs to its test folder instead, read from the container data's TestFolder, so a module's Go and Python tests count as that module's, not
the bridge file's.

### parameter `Test`

A Pester test object (an item of a run's .Tests).

### outputs

`[string]` The run file's absolute path; empty when the test has neither a container folder nor a file.

### example 1

```powershell
$file = Get-TestRunFile -Test $test
```
