---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-PythonTestCases.ps1.md
    kind: comment-page
    body_sha: "836f1e4d933e"
---

# automation/Catzc.Base.QualityGates/private/Get-PythonTestCases.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The language bridge's discovery for Python: Pester discovers the bridge's tests before anything runs, so the
Python tests are read from the source text, never from pytest — discovery stays fast and offline, and works where
uv is missing (the tests then skip). Every test_*.py file below the folder counts, except under a folder whose
name starts with '.' or '_' (an environment, a cache). A Python test is a top-level `def test<name>(`, as pytest
collects it; a parametrised test is one case, as Invoke-PythonTest folds its parametrised results.

Each case carries its package: the file's module path inside the folder, dotted (test_widget, or
nested.test_widget), which is the classname pytest reports with the folder as its rootdir, so it pairs with the
PythonTestResult Invoke-PythonTest returns. The category follows the PythonTestResult rule: test_integrity* is
integrity, everything else logic.
```
