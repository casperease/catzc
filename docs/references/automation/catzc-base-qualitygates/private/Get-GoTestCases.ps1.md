---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-GoTestCases.ps1.md
    kind: comment-page
    body_sha: c2902800707e
---

# automation/Catzc.Base.QualityGates/private/Get-GoTestCases.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The language bridge's discovery for Go: Pester discovers the bridge's tests before anything runs, so the Go tests are read
from the source text, never from the go tool — discovery stays fast and offline, and works where go is missing
(the tests then skip). Every *_test.go file below the folder counts, except under the folders go itself
ignores (a name starting with '.' or '_', and testdata). A Go test is a top-level `func Test<Name>(t
*testing.T)` whose name continues with no lowercase letter, as go test requires.

Each case carries the import path of its package — the module path <module_root>/<folder> from go.yml, plus
the subfolder for a nested package — so it pairs with the GoTestResult Invoke-GoTest returns, and the category
by the GoTestResult rule: TestIntegrity* is integrity, everything else logic.
```
