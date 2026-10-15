---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Select-InScopeTestFiles.ps1.md
    kind: reference
    body_sha: "11ce1e9b0826"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Select-InScopeTestFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A worker filters by tier and category itself (the exclude tags), but only after loading a file and discovering
its tests, so a file whose every test is out of scope costs that load for nothing. Given the run's one discovery
pass (all tests, any tier), this keeps each file holding at least one test in scope (Test-TestInRunScope), so an
L3-only run sends only the L3 files to workers.

A file is dropped only when discovery found tests in it and every one is out of scope. A file with no discovered
test — empty, or one that failed to load — stays, so its worker still reports the failure instead of the run
passing without it. The dropped files' tests are returned for the caller to report as NotRun, as a worker would
have: the skip report, tests.csv, and the rule coverage then read the same rows whether a file was loaded or not.
```
