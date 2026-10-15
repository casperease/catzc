# docs/references/automation/catzc-base-qualitygates/private/Get-PythonCheckScope.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-PythonCheckScope.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every .py file the repository holds takes the Python checks
([ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)): the Python test folders
(Get-LanguageTestFolders, language python — a folder, so a new test file counts before it is committed), and the
tracked .py files anywhere else, such as the agent helpers under .claude/ (Get-GitTrackedPath, read from the index).
```
