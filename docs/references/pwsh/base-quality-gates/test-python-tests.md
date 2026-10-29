# pwsh/Base.QualityGates/Test-PythonTests.ps1

The quality gate for the Python tests of the catzc modules: it runs each module's Python test folder through the language bridge and fails
on any failed test.

## help

### synopsis

Runs the Python test folders of the catzc modules and fails on any failed test.

### description

Takes the Python test folders the language bridge knows (Get-LanguageTestFolders), or the ones named by `-Path`, and runs each through
Invoke-PythonTest, which runs ruff and pytest in the managed uv and returns a result per test. A failed test is a finding reading
`folder: package name failed: first output line`. A path that is not a Python test folder of a module throws. A quality gate: it ends
through Write-QualityGateReport, which writes out/python-tests/, prints every issue, and throws once listing them all. It needs the source
tree: it throws in build mode.

### parameter `Path`

The Python test folders to run, repository-relative. Every Python test folder by default.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/python-tests`.

### parameter `PassThru`

Return a result object instead of throwing.

### outputs

Throws on any finding; with -PassThru, returns the `[Catzc.Base.Reports.QualityGateResult]`.

### example 1

```powershell
Test-PythonTests
```
