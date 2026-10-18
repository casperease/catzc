# automation/Catzc.Base.QualityGates/private/Get-GoTestCases.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the Go tests a Go test folder declares, read from its `*_test.go` files without running go.

### description

The language bridge's discovery for Go: Pester discovers the bridge's tests before anything runs, so the Go tests are read from the source
text, never from the go tool — discovery stays fast and offline, and works where go is missing (the tests then skip). Every `*_test.go` file
below the folder counts, except under the folders go itself ignores (a name starting with '.' or '_', and testdata). A Go test is a
top-level `func Test<Name>(t *testing.T)` whose name continues with no lowercase letter, as go test requires.

Each case carries the import path of its package — the module path `<module_root>/<folder>` from go.yml, plus the subfolder for a nested
package — so it pairs with the GoTestResult Invoke-GoTest returns, and the category by the GoTestResult rule: `TestIntegrity*` is integrity,
everything else logic.

### parameter Folder

The absolute path of the Go test folder (a Get-LanguageTestFolders Folder of language go).

### outputs

`[pscustomobject]` One case per Go test ({ Key; Package; Name; Category; Title }), files in ordinal order and each file's tests in
declaration order. Key is '`<Package>` `<Name>`'; Title is the name, prefixed with the subfolder for a nested package.

### example 1

```powershell
Get-GoTestCases -Folder (Get-LanguageTestFolders | Where-Object Language -EQ go)[0].Folder
```
