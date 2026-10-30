# pwsh/Base.QualityGates/private/Remove-OrphanTestResult.ps1

Deletes the stored test results that no test file can clear any more, and returns the files removed.

## help

### synopsis

Deletes the stored test results that no test file can clear any more.

### description

A result stands for a test file. Once the file is gone, or was never a Pester test file, nothing can clear the result, so it is removed. A
file under `test-results` that is not a result is removed too. A temporary file is removed only when it is over an hour old, since a writer
in flight owns its temporary file and only one a crash left behind is stale.

### parameter `RepositoryRoot`

The root the results' paths are relative to; the repository root by default.

### parameter `OutputRoot`

The output root that holds `test-results`; the repository's by default.

### outputs

`[string[]]` The files removed.

## Walk

The results are listed through `Get-ChildPath` with an explicit depth, so the walk is bounded.
