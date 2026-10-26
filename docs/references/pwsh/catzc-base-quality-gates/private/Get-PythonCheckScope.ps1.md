# pwsh/Base.QualityGates/private/Get-PythonCheckScope.ps1

Lists what the Python checks read: every Python test folder, and every tracked `.py` file outside the Python root. It exists so that every
Python file the repository holds takes the checks, wherever it lives.

## help

### synopsis

Lists what the Python checks read: every Python test folder, and every tracked .py file outside the Python root.

### description

Every .py file the repository holds takes the Python checks
([ADR-AUTO-PY-EVERYFILELINTED](../../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfilelinted)): the Python
test folders (Get-LanguageTestFolders, language python — a folder, so a new test file counts before it is committed), and the tracked .py
files anywhere else, such as the agent helpers under .claude/ (Get-GitTrackedPath, read from the index).

### outputs

`[string]` Full paths: the test folders first, in their order, then the other files in ordinal order. Nothing when the repository holds no
Python.

### example 1

```powershell
$scope = @(Get-PythonCheckScope)
```
