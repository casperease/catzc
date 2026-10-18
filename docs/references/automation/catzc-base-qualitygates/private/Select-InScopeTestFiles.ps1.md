# automation/Catzc.Base.QualityGates/private/Select-InScopeTestFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Keeps the test files with a test inside the run's tier and category scope, and returns the dropped files' tests.

### description

A worker filters by tier and category itself (the exclude tags), but only after loading a file and discovering its tests, so a file whose
every test is out of scope costs that load for nothing. Given the run's one discovery pass (all tests, any tier), this keeps each file
holding at least one test in scope (Test-TestInRunScope), so an L3-only run sends only the L3 files to workers.

A file is dropped only when discovery found tests in it and every one is out of scope. A file with no discovered test — empty, or one that
failed to load — stays, so its worker still reports the failure instead of the run passing without it. The dropped files' tests are returned
for the caller to report as NotRun, as a worker would have: the skip report, tests.csv, and the rule coverage then read the same rows
whether a file was loaded or not.

### parameter Discovery

The run's discovery-only Pester result (Get-TestDiscovery).

### parameter ExcludeTag

The run's tier/category exclude tags (Get-TestExcludeTag).

### parameter TestFiles

The run's candidate test files (absolute `*.Tests.ps1` paths), in run order; tests outside them are ignored.

### outputs

`[pscustomobject]` with Files (the kept files, input order preserved) and OutOfScopeTests (every discovered test of the dropped files, in
run-file order).
