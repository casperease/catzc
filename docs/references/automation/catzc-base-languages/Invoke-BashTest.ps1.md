---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "05571cedbc19"
---

# automation/Catzc.Base.Languages/Invoke-BashTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and -not @($results |...`, written with `#`.

```text
bats exits 1 when a test failed; a non-zero exit with no failing test, or no test at all, means it failed around
the tests (a .bats file that does not parse, a failing setup_file).
```
