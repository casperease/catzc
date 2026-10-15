---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md
    kind: comment-page
    body_sha: f7e594e62bec
---

# automation/Catzc.Base.Languages/Invoke-BashTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and -not @($results |...`.

```text
bats exits 1 when a test failed; a non-zero exit with no failing test, or no test at all, means it failed around
the tests (a .bats file that does not parse, a failing setup_file).
```
