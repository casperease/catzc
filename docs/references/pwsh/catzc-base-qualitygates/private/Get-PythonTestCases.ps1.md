# pwsh/Catzc.Base.QualityGates/private/Get-PythonTestCases.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the Python tests a Python test folder declares, read from its `test_*.py` files without running Python.

### description

The language bridge's discovery for Python: Pester discovers the bridge's tests before anything runs, so the Python tests are read from the
source text, never from pytest — discovery stays fast and offline, and works where uv is missing (the tests then skip). Every `test_*.py`
file below the folder counts, except under a folder whose name starts with '.' or '_' (an environment, a cache). A Python test is a
top-level `def test<name>(`, as pytest collects it; a parametrised test is one case, as Invoke-PythonTest folds its parametrised results.

Each case carries its package: the file's module path inside the folder, dotted (test_widget, or nested.test_widget), which is the classname
pytest reports with the folder as its rootdir, so it pairs with the PythonTestResult Invoke-PythonTest returns. The category follows the
PythonTestResult rule: `test_integrity*` is integrity, everything else logic.

### parameter `Folder`

The absolute path of the Python test folder (a Get-LanguageTestFolders Folder).

### outputs

`[pscustomobject]` One case per Python test ({ Key; Package; Name; Category; Title }), files in ordinal order and each file's tests in
declaration order. Key is '`<Package>` `<Name>`'; Title is the name, prefixed with the package for a file other than the folder's single
top-level one.

### example 1

```powershell
Get-PythonTestCases -Folder (Get-LanguageTestFolders | Where-Object Language -EQ python)[0].Folder
```
